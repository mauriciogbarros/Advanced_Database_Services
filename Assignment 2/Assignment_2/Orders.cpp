#include "Orders.h"

void displayOrderStatus(Connection* conn, int orderId, int customerId)
{
	// Call customer_order to confirm orderId
	// If 
	Statement* statement = conn->createStatement("BEGIN customer_order(:1, :2); END;");
	std::string status{};
	statement->setInt(1, customerId);
	statement->setInt(2, orderId);
	statement->execute();
	orderId = statement->getInt(2);

	if (orderId != 0)
	{
		statement = conn->createStatement("BEGIN display_order_status(:1, :2); END;");
		statement->setInt(1, orderId);
		statement->registerOutParam(2, Type::OCCISTRING, sizeof(status));
		statement->execute();

		status = statement->getString(2);
		
		if (status != "")
		{
			std::cout << "Order is " << status << std::endl;
		}
		else
			std::cout << "Order does not exist" << std::endl;
	}
	else
		std::cout << "Order ID is not valid" << std::endl;

	
	conn->terminateStatement(statement);
}

void cancelOrder(Connection* conn, int orderId, int customerId)
{
	std::cout << "Cancel Order" << std::endl;
	std::cout << "order: " << orderId << std::endl;
	std::cout << "customer: " << customerId << std::endl;
}