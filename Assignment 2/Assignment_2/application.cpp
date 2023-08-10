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

int customerLogin(Connection* conn, int customerId)
{
	return 0;
}

int addToCart(Connection* conn, struct ShoppingCart cart[])
{
	return 0;
}

double findProduct(Connection* conn, int productId)
{
	return 0;
}

void displayProducts(struct ShoppingCart cart[], int productCount)
{
	;
}

int checkout(Connection* conn, struct ShoppingCart cart[], int customerId, int productCount)
{
	return 0;
}