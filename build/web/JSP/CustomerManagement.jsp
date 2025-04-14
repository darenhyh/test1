<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Customer Management</title>
    <link href="../CSS/style.css" rel="stylesheet" type="text/css">
    <link href="../CSS/admin.css" rel="stylesheet" type="text/css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        .content-table {
            border-collapse: collapse;
            margin: 25px 0;
            font-size: 0.9em;
            min-width: 400px;
            width: 100%;
            border-radius: 5px 5px 0 0;
            overflow: hidden;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.15);
        }
        
        .content-table thead tr {
            background-color: #f8e682;
            color: #000000;
            text-align: left;
            font-weight: bold;
        }
        
        .content-table th,
        .content-table td {
            padding: 12px 15px;
        }
        
        .content-table tbody tr {
            border-bottom: 1px solid #dddddd;
        }
        
        .content-table tbody tr:nth-of-type(even) {
            background-color: #f3f3f3;
        }
        
        .content-table tbody tr:last-of-type {
            border-bottom: 2px solid #f8e682;
        }
        
        .content-table tbody tr.active-row {
            font-weight: bold;
            color: #f8e682;
        }
        
        .action-btns {
            display: flex;
            gap: 10px;
        }
        
        .action-btns a {
            text-decoration: none;
            padding: 5px 10px;
            border-radius: 4px;
            color: white;
        }
        
        .edit-btn {
            background-color: #4CAF50;
        }
        
        .delete-btn {
            background-color: #f44336;
        }
        
        .add-btn {
            background-color: #008CBA;
            color: white;
            padding: 10px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            float: right;
            margin-bottom: 20px;
            text-decoration: none;
        }
        
        .notification {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 4px;
        }
        
        .success {
            background-color: #dff0d8;
            color: #3c763d;
            border: 1px solid #d6e9c6;
        }
        
        .error {
            background-color: #f2dede;
            color: #a94442;
            border: 1px solid #ebccd1;
        }
        
        .search-container {
            margin-bottom: 20px;
        }
        
        #searchInput {
            padding: 8px;
            width: 30%;
            margin-right: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
    </style>
</head>
<body>
    <section id="header">
        <div class="header-left">
            <a href="../JSP/GuestHome.jsp"><img src="../IMG/logo.jpg" alt="Index" width="180" height="70"></a>
        </div>
        <div class="header-right">
            <input type="text" placeholder="Search.."><img src="../ICON/search.svg" width="30" height="30">
            <a href="../JSP/Admin/dashboard.jsp">Dashboard</a>
            <a href="../JSP/Admin/CustomerManagement.jsp">Customers</a>
            <a href="#">Products</a>
            <a href="#">Orders</a>
            <a href="../JSP/Login.jsp">Logout</a>
        </div>
    </section>
    
    <div class="container">
        <h1>Customer Management</h1>
        
        <c:if test="${not empty message}">
            <div class="notification ${message.contains('successfully') ? 'success' : 'error'}">
                ${message}
            </div>
        </c:if>
        
        <a href="<c:url value='/CustomerManagement?action=new'/>" class="add-btn">Add New Customer</a>
        
        <div class="search-container">
            <input type="text" id="searchInput" placeholder="Search customers...">
        </div>
        
        <table class="content-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Username</th>
                    <th>Email</th>
                    <th>Mobile No</th>
                    <th>Birth Date</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody id="customerTableBody">
                <c:forEach var="customer" items="${customers}">
                    <tr>
                        <td>${customer.id}</td>
                        <td>${customer.name}</td>
                        <td>${customer.username}</td>
                        <td>${customer.email}</td>
                        <td>${customer.mobileNo}</td>
                        <td>${customer.birth}</td>
                        <td class="action-btns">
                            <a href="<c:url value='/CustomerManagement?action=edit&id=${customer.id}'/>" class="edit-btn">Edit</a>
                            <a href="#" onclick="confirmDelete(${customer.id})" class="delete-btn">Delete</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <script>
        // Search functionality
        $(document).ready(function(){
            $("#searchInput").on("keyup", function() {
                var value = $(this).val().toLowerCase();
                $("#customerTableBody tr").filter(function() {
                    $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
                });
            });
        });
        
        // Confirm delete
        function confirmDelete(id) {
            if (confirm("Are you sure you want to delete this customer?")) {
                window.location.href = "<c:url value='/CustomerManagement?action=delete&id='/>" + id;
            }
        }
        
        // Auto-hide notifications after 5 seconds
        setTimeout(function() {
            $(".notification").fadeOut("slow");
        }, 5000);
    </script>
</body>
</html>