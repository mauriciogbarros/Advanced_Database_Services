#include "application.h"

void displayOrderStatus(Connection* conn, int orderId, int customerId)
{
	Statement* stmt{};
	try
	{
		// Call customer_order to confirm orderId
		stmt = conn->createStatement("BEGIN customer_order(:1, :2); END;");
		std::string status{};
		stmt->setInt(1, customerId);
		stmt->setInt(2, orderId);
		stmt->execute();
		orderId = stmt->getInt(2);

		// If orderId is valid
		// Check the order status
		if (orderId != 0)
		{
			stmt = conn->createStatement("BEGIN display_order_status(:1, :2); END;");
			stmt->setInt(1, orderId);
			stmt->registerOutParam(2, Type::OCCISTRING, sizeof(status));
			stmt->execute();
			status = stmt->getString(2);

			if (status != "")
				std::cout << "Order is " << status << std::endl;
			else
				std::cout << "Order does not exist" << std::endl;
		}
		else
			std::cout << "Order ID is not valid" << std::endl;
		conn->terminateStatement(stmt);
	}
	catch (SQLException& sqlExcp)
	{
		std::cout << sqlExcp.getErrorCode() << ": " << sqlExcp.getMessage();
	}
}

void cancelOrder(Connection* conn, int orderId, int customerId)
{
	Statement* stmt{};
	int cancelStatus{};
	try
	{
		stmt = conn->createStatement("BEGIN cancel_order(:1, :2); END;");
		stmt->setInt(1, orderId);
		stmt->setInt(2, cancelStatus);
		stmt->execute();
		cancelStatus = stmt->getInt(2);

		switch (cancelStatus)
		{
		case 0:
			std::cout << "Order ID is not valid\n";
			break;
		case 1:
			std::cout << "The order has been already canceled\n";
			break;
		case 2:
			std::cout << "The order is shipped and cannot be canceled\n";
			break;
		case 3:
			std::cout << "The order is canceled successfully\n";
			break;
		}

		conn->terminateStatement(stmt);
	}
	catch (SQLException& sqlExcp)
	{
		std::cout << sqlExcp.getErrorCode() << ": " << sqlExcp.getMessage();
	}
}

int mainMenu()
{
	bool correctInput{ false };
	int input{};

	std::cout << "******************** Main Menu ********************\n";
	std::cout << "1)      Login\n";
	std::cout << "0)      Exit\n";
	std::cout << "Enter an option (0-1): ";
	std::cin >> input;

	while (!correctInput)
	{
		if (input == 0 || input == 1)
			correctInput = true;
		else
		{
			std::cout << "******************** Main Menu ********************\n";
			std::cout << "1)      Login\n";
			std::cout << "0)      Exit\n";
			std::cout << "You entered a wrong value. Enter an option (0-1): ";
			std::cin >> input;
		}
	}

	return input;
}

int subMenu()
{
	bool correctInput{ false };
	int input{};

	while (!correctInput)
	{
		std::cout << "************** Customer Service Menu **************\n";
		std::cout << "1) Place an order\n";
		std::cout << "2) Check an order status\n";
		std::cout << "3) Cancel an order\n";
		std::cout << "0) Exit\n";
		std::cout << "Enter an option (0-3): ";
		std::cin >> input;

		if (input >= 0 && input <= 3)
			correctInput = true;
	}

	return input;
}

int customerLogin(Connection* conn, int customerId)
{
	Statement* stmt{};
	bool customerFound{};
	try
	{
		// Call find_customer
		stmt = conn->createStatement("BEGIN find_customer(:1, :2); END;");
		stmt->setInt(1, customerId);
		stmt->setInt(2, customerFound);
		stmt->execute();
		customerFound = stmt->getInt(2);
		conn->terminateStatement(stmt);
		return customerFound;
	}
	catch (SQLException& sqlExcp)
	{
		std::cout << sqlExcp.getErrorCode() << ": " << sqlExcp.getMessage();
	}
}

int addToCart(Connection* conn, struct ShoppingCart cart[])
{
	bool moreProducts{ true };
	int productId{};
	int n_items;
	double productPrice{};
	
	n_items = sizeof(*cart) / (2 * sizeof(int) + sizeof(double));

	std::cout << "-------------- Add Products to Cart ---------------\n";
	while (n_items < 5 && moreProducts)
	{
		std::cout << "N Items: " << n_items << std::endl;
		std::cout << "Enter the product ID: ";
		std::cin >> productId;
		productPrice = findProduct(conn, productId);

		if (productPrice > 0)
		{
			cart[n_items].product_id = productId;
			cart[n_items].price = productPrice;
			std::cout << "Product Price: " << cart[n_items].price << std::endl;
			std::cout << "Enter the product Quantity: ";
			std::cin >> cart[n_items].quantity;
			n_items++;
			if (n_items < 5)
			{
				std::cout << "Enter 1 to add more products or 0 to checkout: ";
				std::cin >> moreProducts;
			}
		}
		else
			std::cout << "The product does not exist. Try again...\n";
	}
	return n_items;
}

double findProduct(Connection* conn, int productId)
{
	double productPrice{};
	std::string productName{};
	Statement* stmt{};
	
	try 
	{
		stmt = conn->createStatement("BEGIN find_product(:1, :2, :3); END;");
		stmt->setInt(1, productId);
		stmt->setDouble(2, productPrice);
		stmt->registerOutParam(3, Type::OCCISTRING, sizeof(productName));
		stmt->execute();
		productPrice = stmt->getDouble(2);
		productName = stmt->getString(3);

		return productPrice;
	}
	catch (SQLException& sqlExcp)
	{
		std::cout << sqlExcp.getErrorCode() << ": " << sqlExcp.getMessage();
	}
}

void displayProducts(struct ShoppingCart cart[], int productCount)
{
	double total{};

	std::cout << "------- Ordered Products -------\n";
	for (int i = 0; i < productCount; i++)
	{
		total += cart[i].price * cart[i].quantity;
		std::cout << "---Item " << i + 1 << std::endl;
		std::cout << "Product ID: " << cart[i].product_id << std::endl;
		std::cout << "Price: " << cart[i].price << std::endl;
		std::cout << "Quantity: " << cart[i].quantity << std::endl;
	}
	std::cout << "----------------------------------\n";
	std::cout << "Total: " << total << std::endl;
}

int checkout(Connection* conn, struct ShoppingCart cart[], int customerId, int productCount)
{
	char input{};
	bool correctInput{ false };
	bool goToCheckout{};

	while (!correctInput)
	{
		std::cout << "Would you like to checkout? (Y/y or N/n)";
		std::cin >> input;
		input = toupper(input);
		if (input == 'Y' || input == 'N')
			correctInput = true;
		else
			std::cout << "Wrong input. Try again...\n";
	}
	if (input == 'Y')
		goToCheckout = true;
	else
		goToCheckout = false;

	return goToCheckout;
}