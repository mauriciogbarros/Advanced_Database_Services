#pragma once

#include <iostream>
#include <occi.h>
#include <string>

using oracle::occi::Environment;
using oracle::occi::Connection;
using namespace oracle::occi;

void displayOrderStatus(Connection* conn, int orderId, int customerId);
void cancelOrder(Connection* conn, int orderId, int customerId);