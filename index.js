import express from 'express';
import pg from 'pg';
import jsSHA from 'jssha';
import cookieParser from 'cookie-parser';

// Initialise DB connection
const { Pool } = pg;
const pgConnectionConfigs = {
  user: 'smdewi',
  host: 'localhost',
  database: 'lab_buddy',
  port: 5432,
};
const pool = new Pool(pgConnectionConfigs);

const app = express();
app.set('view engine', 'ejs');
app.use(express.static('public'));
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());

// Check user authentication
// If user is a customer && is listed in the user table && the password matched then get the route
app.post('/login', (request, response) => {
  // retrieve the user entry using their email
  const values = [request.body.username];
  console.log(values);
  pool.query('SELECT * from users WHERE username=$1', values, (error, result) => {
    // return if there is a query error
    if (error) {
      console.log('Error executing query', error.stack);
      response.status(503).send(result.rows);
      return;
    }

    // we didnt find a user with that email
    if (result.rows.length === 0) {
      // the error for incorrect email and incorrect password are the same for security reasons.
      // This is to prevent detection of whether a user has an account for a given service.
      response.status(403).send('login failed!');
      return;
    }

    // get user record from results
    const user = result.rows[0];
    console.log('User:', user);
    // initialise SHA object
    const shaObj = new jsSHA('SHA-512', 'TEXT', { encoding: 'UTF8' });
    // input the password from the request to the SHA object
    shaObj.update(request.body.password);
    // get the hashed value as output from the SHA object
    const hashedPassword = shaObj.getHash('HEX');

    // eslint-disable-next-line max-len
    // If the user's hashed password in the database does not match the hashed input password, login fails
    if (user.password !== hashedPassword) {
      // the error for incorrect email and incorrect password are the same for security reasons.
      // This is to prevent detection of whether a user has an account for a given service.
      response.status(403).send('login failed!');
      return;
    }

    // The user's password hash matches that in the DB and we authenticate the user.
    response.cookie('user_id', user.id);
    // response.send('logged in!');
    response.redirect('/user/new_order');
  });
});
// Render Login page
app.get('/login', (request, response) => {
  response.render('login2');
});

app.get('/user/order_status', (request, response) => {
  console.log('request came in');

  const whenDoneWithQuery = (error, result) => {
    if (error) {
      console.log('Error executing query', error.stack);
      response.status(503).send(result.rows);
      return;
    }
    console.table(result.rows);
    response.send(result.rows);
  };

  // Query using pg.Pool instead of pg.Client
  pool.query('SELECT * from orders WHERE customer_id = 1', whenDoneWithQuery);
});

// Check lab user authentication and authorisation, then get the route
app.get('/lab/order_status', (request, response) => {
  console.log('request came in');

  const whenDoneWithQuery = (error, result) => {
    if (error) {
      console.log('Error executing query', error.stack);
      response.status(503).send(result.rows);
      return;
    }
    console.table(result.rows);
    // response.send(result.rows);
    const order = result.rows;
    console.log(order);
    response.render('order-status', { order });
  };

  // Query using pg.Pool instead of pg.Client
  pool.query('SELECT * FROM orders INNER JOIN customers ON customers.id = orders.customer_id', whenDoneWithQuery);
});

app.get('/lab/check_order', (request, response) => {
  response.render('check-order');
});

app.post('/lab/check_order', (request, response) => {
  // retrieve the user entry
  const values = [request.body.order_number];
  console.log(values);
  pool.query('SELECT * from orders WHERE orders.id=$1', values, (error, result) => {
    // return if there is a query error
    if (error) {
      console.log('Error executing query', error.stack);
      response.status(503).send(result.rows);
      return;
    }

    // if order number doesn't exist in orders table
    if (result.rows.length === 0) {
      response.status(403).send('No such order');
      return;
    }

    // get user record from results
    const order = result.rows[0];
    console.log('Order:', order);
    // response.send('Will display order here');
    response.render('order-status.ejs', { order });
  });
});

app.get('/user/new_order', (request, response) => {
  response.render('order-form');
});

app.post('/user/new_order', (request, response) => {
  // eslint-disable-next-line max-len
  const valuesPatient = [request.body.patient_name, request.body.patient_nric, request.body.patient_dob, request.body.patient_address, request.body.patient_city, request.body.patient_country, request.body.patient_postal, request.body.patient_email, request.body.patient_phone];
  console.log(valuesPatient);
  pool.query('INSERT INTO patients (patient_name, patient_nric, patient_dob, patient_address, patient_city, patient_country, patient_postal, patient_email, patient_phone) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) RETURNING id', valuesPatient, (error, result) => {
    // return if there is a query error
    if (error) {
      console.log('Error executing query', error.stack);
      response.status(503).send(result.rows);
    }

    // if query is successful
    const patient = result.rows[0];
    console.log('Patient ID: ', patient);
    response.render('order-form2', { patient });
  });
});

app.get('/user/new_order2', (request, response) => {
  response.render('order-form2');
});

app.post('/user/new_order2', (request, response) => {
  // eslint-disable-next-line max-len
  const valuesNewOrder = [request.body.user_id, request.body.patient_id, request.body.order_date];
  console.log(valuesNewOrder);
  console.log(request.cookies.user_id);
  pool.query('INSERT INTO orders (user_id, patient_id, order_date) VALUES ($1, $2, $3)', valuesNewOrder, (error, result) => {
    // return if there is a query error
    if (error) {
      console.log('Error executing query', error.stack);
      response.status(503).send(result.rows);
    }

    // if query is successful
    const newOrder = result.rows[0];
    console.log('New order: ', newOrder);
    // response.send('Patients table updated. Orders table updated.');
    response.render('order-form3');
  });
});

app.get('/user/new_order3', (request, response) => {
  response.render('order-form3');
});

app.post('/user/new_order3', (request, response) => {
  // eslint-disable-next-line max-len
  const valuesNewOrder = [request.body.order_id, request.body.test_id];
  console.log(valuesNewOrder);
  pool.query('INSERT INTO orders_tests (order_id, orderedtest_id) VALUES ($1, $2)', valuesNewOrder, (error, result) => {
    // return if there is a query error
    if (error) {
      console.log('Error executing query', error.stack);
      response.status(503).send(result.rows);
    }

    // if query is successful
    const newOrder = result.rows[0];
    console.log('New order: ', newOrder);
    // eslint-disable-next-line max-len
    // response.send('Patients table updated. Orders table updated. Orders_tests table updated. New order done');
    const index = request.body.order_id;
    response.redirect(`/user/order/${index}`);
  });
});

// Get route to render a single order
app.get('/user/order/:order_id', (request, response) => {
  const index = request.params.order_id;
  console.log('Index:', index);
  pool.query(`SELECT order_id, test_id, name AS test_name, color AS tube_color FROM orders_tests INNER JOIN tests_tubes ON tests_tubes.test_id = orderedtest_id INNER JOIN tubes ON tubes.id = tests_tubes.tube_id INNER JOIN tests ON tests.id = tests_tubes.test_id WHERE order_id = ${index}`, (error, result) => {
    if (error) {
      console.log('Query Error');
      response.status(503).send(result.rows);
    }
    const records = result.rows;
    console.log('Order test data:', records);
    response.render('order', { records });
  });
});

// Get route to render all orders for a specific user
app.get('/user/order_all', (request, response) => {
  // Get userID from cookies
  const userID = request.cookies.user_id;
  console.log('UserID:', userID);
  console.log('Cookies:', request.cookies.user_id);
  pool.query(`SELECT username AS order_placed_by, patient_name, order_date, order_status FROM orders
INNER JOIN users ON orders.user_id = users.id
INNER JOIN patients ON orders.patient_id = patients.id
WHERE orders.user_id = ${userID}`, (error, result) => {
    if (error) {
      console.log('Query Error');
      response.status(503).send(result.rows);
    }
    const records = result.rows;
    console.log('Order:', records);
    // response.send('A List of all orders by one user');
    response.render('order-list', { records });
  });
});

app.get('/user/logout', (request, response) => {
  response.clearCookie('user_id');
  response.clearCookie('loggedIn');
  response.redirect('/login');
});

app.listen(3004);
