# CMS Rails Application

This is a CMS built using Ruby on Rails. It includes different roles like Superadmin, Manager, and Sales. Follow the setup instructions to get the application running on your local machine.

## Setup Instructions

### Clone the Repository

1. Clone the repository to your local machine:

2. Navigate to the project directory:
    ```bash
    cd your-repository-name
    ```

### Install Dependencies

3. Install the required gems:
    ```bash
    bundle install
    ```

### Configure the Database

4. Set up your database configuration. Copy the example database configuration file and modify it according to your environment:
    ```bash
    cp config/database.yml.example config/database.yml
    ```

5. Create the database:
    ```bash
    rails db:create
    ```

6. Run the database migrations:
    ```bash
    rails db:migrate
    ```

7. Seed the database with default data:
    ```bash
    rails db:seed
    ```

### Default Users

Upon seeding the database, the following default users will be created:

- **Superadmin**  
  Email: `superadmin@example.com`  
  Role: Superadmin

- **Manager**  
  Email: `manager@example.com`  
  Role: Manager

- **Sales**  
  Email: `sales@example.com`  
  Role: Sales

### Running the Application

8. To start the application, run:
    ```bash
    rails server
    ```

Visit `http://localhost:3000` in your browser to access the application.

---

Feel free to modify and extend the CMS as needed.

## Contributing

If you'd like to contribute to this project, please fork the repository and submit a pull request with your changes. All contributions are welcome!

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
