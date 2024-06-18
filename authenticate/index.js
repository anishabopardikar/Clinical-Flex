import express from "express";
import bodyParser from "body-parser";
import mysql from "mysql2/promise";
import session from "express-session";

const app = express();
const port = 3000;


const db_w = mysql.createPool({
  host: "localhost",
  user: "root",
  password: "Password",
  database: "clinical_flex"
});

const db_try = mysql.createPool({
  host: "localhost",
  user: "root",
  password: "Password",
  database: "dbms_deadline"
});

app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static("public"));
app.use(express.json());
app.use(session({
  secret: 'your_secret_key', // replace with your own secret key
  resave: false,
  saveUninitialized: true
}));

app.get("/", (req, res) => {
  res.render("home.ejs");
});

app.get("/login", (req, res) => {
  res.render("login.ejs");
});

app.get("/register", (req, res) => {
  res.render("register.ejs");
});

app.post("/register", async (req, res) => {
  const { name, addressLine1, addressLine2, city, stateProvince, country, postalCode, username: email, password } = req.body;
  try {
    const [rows] = await db_try.query("SELECT * FROM customers WHERE email = ?", [email]);
    if (rows.length > 0) {
      res.send("Email already exists. Try logging in.");
    } else {
      // Query the table for the maximum CustomerNumber
      const [maxCustomerNumberRows] = await db_try.query("SELECT MAX(CustomerNumber) as maxCustomerNumber FROM customers");
      const maxCustomerNumber = maxCustomerNumberRows[0].maxCustomerNumber;
      const newCustomerNumber = maxCustomerNumber ? maxCustomerNumber + 1 : 1;

      // Use newCustomerNumber in your INSERT statement
      await db_try.query("INSERT INTO customers (CustomerNumber, Name, AddressLine1, AddressLine2, City, StateProvince, Country, PostalCode, email, Login_password) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", 
      [newCustomerNumber, name, addressLine1, addressLine2, city, stateProvince, country, postalCode, email, password]);
      
      req.session.user = { CustomerID : newCustomerNumber, name, email}; // Save user data in session
      
      res.redirect("/secrets"); // Redirect to secrets route
    }
  } catch (err) {
    console.log(err);
  }
});



app.post("/login", async (req, res) => {
  const email = req.body.username;
  const password = req.body.password;
  if (!email || !password) {
    return res.send("Please enter email and password");
  }
  if (email==="admin@admin.com" && password==="admin") {
    return res.redirect("/admin");
  }
  try {
    const [rows] = await db_try.query("SELECT * FROM customers WHERE email = ?", [email]);
    if (rows.length > 0) {
      const user = rows[0];
      if (!user.isBanned) {
        console.log(user);
        const storedPassword = user.Login_password;
        if (password == storedPassword) {
          req.session.user = user; // Save user data in session
          console.log(req.session.user);
          await db_try.query("INSERT INTO Login_History(CutomerNumberUsed, isSuccess) VALUES( ? , ? )", [user.CustomerNumber, true]);
          res.redirect("/secrets");
        } else {
          await db_try.query("INSERT INTO Login_History(CutomerNumberUsed, isSuccess) VALUES( ? , ? )", [user.CustomerNumber, false]);
          res.send("Incorrect Password");
        }
      } 
      else {
        res.send("User is banned");
      }
    } else {
      res.send("User not found");
    }
  } catch (err) {
    console.log(err);
  }
});

app.get("/admin", async (req, res) => {
  try {
    // Execute the SQL queries
    const [expiryRows, expiryFields] = await db_try.execute("SELECT Distinct p.Product_name, i.Drug_Description, i.Quantity_on_Hand as Total_Quantity, p.Recent_date_of_expiry FROM products p INNER JOIN inventory i ON p.productid = i.productid ORDER BY Recent_date_of_expiry ASC LIMIT 10");


    const [orderedRows, orderedFields] = await db_try.execute('SELECT p.Product_Name, ANY_VALUE(i.Drug_Description ) as About_drug,  ANY_VALUE(p.Average_Price) as Price, ANY_VALUE(p.Total_Quantity) as ProductQuantity, COUNT (*) as Frequency FROM Prescription pr INNER JOIN Products p ON pr.Drug_Name = p.Product_Name INNER JOIN (SELECT DISTINCT ProductID, Drug_Description FROM Inventory) as i ON p.ProductID = i.ProductID GROUP BY pr.Drug_Name ORDER BY Frequency DESC LIMIT 10;' );

    // Render the view with the data
    res.render("admin.ejs", { expiryProducts: expiryRows, orderedProducts: orderedRows });
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Server Error');
  }
});



app.get("/secrets", (req, res) => {
  if (req.session.user) { // Check if user is logged in
    res.render("secrets.ejs", { user: req.session.user }); // Pass user data to the view
  } else {
    res.redirect("/login"); // Redirect to login page if not logged in
  }
});

app.get('/logout', (req, res) => {
  req.session.destroy((err) => {
    if(err) {
      return console.log(err);
    }
    res.redirect('/login'); // Redirect to login page after successful logout
  });
});



app.post('/myFunction', async (req, res) => {
  const drugName = req.body.drug_Name;
  console.log(drugName + " This is backend function");
  let sql = `SELECT Distinct p.Product_name, p.Average_price, i.Drug_Description 
  FROM products p 
  INNER JOIN inventory i ON p.productid = i.productid 
  WHERE p.Product_name LIKE CONCAT('%', ?, '%');
  `;
  try {
    const [rows, fields] = await db_try.execute(sql, [drugName]);
    console.log(rows);
    req.session.products = rows; // Save the data in session
    req.session.searched = drugName;
    res.redirect("/products"); // Redirect to /products
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Server Error');
  }
});

app.get("/products", async (req, res) => {
  let products = req.session.products; // Get the data from session
  let searched = req.session.searched;

  // If no products in session, call /myFunction logic
  if (!products && searched) {
    const drugName = searched;
    console.log(drugName + " This is backend function");
    let sql = `SELECT Distinct p.Product_name, p.Average_price, i.Drug_Description 
    FROM products p 
    INNER JOIN inventory i ON p.productid = i.productid 
    WHERE p.Product_name LIKE CONCAT('%', ?, '%');
    `;
    try {
      const [rows, fields] = await db_try.execute(sql, [drugName]);
      console.log(rows);
      products = rows; // Save the data in session
    } catch (err) {
      console.error(err.message);
      res.status(500).send('Server Error');
      return;
    }
  }

  console.log("----------------");
  console.log(products);
  res.render("products.ejs", {  user: req.session.user, products: products, searched : searched }); // Pass products to the view
});


app.post("/order", async (req, res) => {
  // Extract order details from the request body
  const { productId, quantity } = req.body;

  // Get the customer ID from the session
  console.log(req.session.user);
  const customerId = req.session.user.CustomerNumber;

  // Start a new transaction
  const connection = await db_try.getConnection();
  await connection.beginTransaction();

  try {
    // Acquire table-level locks
    await connection.query("LOCK TABLES Inventory WRITE, Orders WRITE");
    console.log("product id is " + productId + " quantity is " + quantity + " customer id is " + customerId);
    // Check if there's enough quantity in stock
    const [inventoryRows] = await connection.query("SELECT Quantity_on_Hand FROM Inventory WHERE ProductID = ?", [productId]);
    if (inventoryRows.length > 0 && inventoryRows[0].Quantity_on_Hand >= quantity) {
      // Update the inventory
      await connection.query("UPDATE Inventory SET Total_Quantity = Quantity_on_Hand - ? WHERE ProductID = ?", [quantity, productId]);

      // Insert a new order
      await connection.query("INSERT INTO Orders (CustomerNumber, ProductID, Quantity, OrderDate) VALUES (?, ?, ?, NOW())", [customerId, productId, quantity]);

      // Commit the transaction
      await connection.commit();

      res.send("Order placed successfully");
    } else {
      // Rollback the transaction
      await connection.rollback();

      res.send("Insufficient quantity in stock");
    }
  } catch (err) {
    // If any error occurred, rollback the transaction
    await connection.rollback();

    console.log(err);
    res.send("An error occurred while placing the order");
  } finally {
    // Release the locks and the connection
    await connection.query("UNLOCK TABLES");
    connection.release();
  }
});


app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
