<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Edit Customer</title>
    <link href="../CSS/style.css" rel="stylesheet" type="text/css">
    <link href="../CSS/admin.css" rel="stylesheet" type="text/css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        .container {
            width: 80%;
            margin: 0 auto;
            padding: 20px;
        }
        
        fieldset {
            border: 1px solid #ddd;
            padding: 20px;
            margin-bottom: 20px;
            border-radius: 5px;
        }
        
        .form-group {
            margin-bottom: 15px;
            display: flex;
            flex-direction: column;
        }
        
        .form-group label {
            margin-bottom: 5px;
            font-weight: bold;
        }
        
        .form-control {
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            width: 100%;
            box-sizing: border-box;
        }
        
        .btn {
            padding: 10px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            color: white;
        }
        
        .btn-primary {
            background-color: #4CAF50;
        }
        
        .btn-secondary {
            background-color: #f44336;
        }
        
        .btn-container {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
        }
        
        .validation-message {
            color: red;
            font-size: 12px;
            margin-top: 5px;
        }
        
        .valid-message {
            color: green;
            font-size: 12px;
            margin-top: 5px;
        }
        
        /* Password validation styles */
        .invalid {
            color: red;
        }
        
        .valid {
            color: green;
        }
        
        .notification {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 4px;
        }
        
        .error {
            background-color: #f2dede;
            color: #a94442;
            border: 1px solid #ebccd1;
        }
        
        .success {
            background-color: #dff0d8;
            color: #3c763d;
            border: 1px solid #d6e9c6;
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
        <h1>Edit Customer</h1>
        
        <c:if test="${not empty message}">
            <div class="notification ${message.contains('successfully') ? 'success' : 'error'}">
                ${message}
            </div>
        </c:if>
        
        <form action="<c:url value='/CustomerManagement?action=update'/>" method="post" id="editForm">
            <input type="hidden" name="id" value="${customer.id}">
            
            <fieldset>
                <legend>Customer Information</legend>
                
                <div class="form-group">
                    <label for="name">Full Name:</label>
                    <input type="text" class="form-control" id="name" name="name" value="${customer.name}" required>
                    <div id="nameValidation"></div>
                </div>
                
                <div class="form-group">
                    <label for="username">Username:</label>
                    <input type="text" class="form-control" id="username" name="username" value="${customer.username}" required>
                    <div id="usernameValidation"></div>
                </div>
                
                <div class="form-group">
                    <label for="birth">Birth Date:</label>
                    <input type="date" class="form-control" id="birth" name="birth" value="${customer.birth}" required>
                    <div id="birthValidation"></div>
                </div>
                
                <div class="form-group">
                    <label for="email">Email:</label>
                    <input type="email" class="form-control" id="email" name="email" value="${customer.email}" required>
                    <div id="emailValidation"></div>
                </div>
                
                <div class="form-group">
                    <label for="mobileNo">Mobile Number:</label>
                    <input type="tel" class="form-control" id="mobileNo" name="mobileNo" pattern="01[0-9]-[0-9]{7,10}" value="${customer.mobileNo}" required>
                    <div id="phoneValidation"></div>
                </div>
                
                <div class="form-group">
                    <label for="password">Password:</label>
                    <input type="password" class="form-control" id="password" name="password" value="${customer.password}" pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}" required>
                    <div id="passwordMessage" style="display: none;">
                        <h3 style="font-size: 15px;">Password must contain the following:</h3>
                        <p id="letter" class="invalid" style="font-size: 13px;">✖ A <b>lowercase</b> letter</p>
                        <p id="capital" class="invalid" style="font-size: 13px;">✖ A <b>capital (uppercase)</b> letter</p>
                        <p id="number" class="invalid" style="font-size: 13px;">✖ A <b>number</b></p>
                        <p id="length" class="invalid" style="font-size: 13px;">✖ Minimum <b>8 characters</b></p>
                    </div>
                </div>
            </fieldset>
            
            <div class="btn-container">
                <a href="<c:url value='/CustomerManagement'/>" class="btn btn-secondary">Cancel</a>
                <button type="submit" class="btn btn-primary">Update Customer</button>
            </div>
        </form>
    </div>

    <script>
        // Full name validation
        $(document).ready(function () {
            $('#name').on('keyup', function () {
                var fullName = $(this).val();
                var regex = /^[A-Za-z\s/]+$/; // Only letters, spaces, and '/'

                if (fullName.length > 0) {
                    if (!regex.test(fullName)) {
                        $('#nameValidation').html('<span class="validation-message">Invalid characters detected! Only alphabets, spaces, and "/" are allowed.</span>');
                        $('button[type="submit"]').prop('disabled', true);
                    } else {
                        $.ajax({
                            type: 'POST',
                            url: '/GlowyDays/ValidateName',
                            data: { name: fullName },
                            success: function (response) {
                                if (response.trim() === "Valid Name") {
                                    $('#nameValidation').html('<span class="valid-message">Valid Name!</span>');
                                    $('button[type="submit"]').prop('disabled', false);
                                } else {
                                    $('#nameValidation').html('<span class="validation-message">Invalid Name.</span>');
                                    $('button[type="submit"]').prop('disabled', true);
                                }
                            },
                            error: function () {
                                $('#nameValidation').html('<span class="validation-message">Error validating name.</span>');
                                $('button[type="submit"]').prop('disabled', true);
                            }
                        });
                    }
                } else {
                    $('#nameValidation').html('');
                    $('button[type="submit"]').prop('disabled', false);
                }
            });
            
            // Username validation
            $('#username').on('keyup', function () {
                var username = $(this).val();
                
                if (username.length > 0) {
                    $.ajax({
                        type: 'POST',
                        url: '/GlowyDays/ValidateUsername',
                        data: { username: username, currentId: ${customer.id} },
                        success: function (response) {
                            if (response.trim() === "Available") {
                                $('#usernameValidation').html('<span class="valid-message">Username is available!</span>');
                                $('button[type="submit"]').prop('disabled', false);
                            } else {
                                $('#usernameValidation').html('<span class="validation-message">Username is already taken.</span>');
                                $('button[type="submit"]').prop('disabled', true);
                            }
                        },
                        error: function () {
                            $('#usernameValidation').html('<span class="validation-message">Error checking username.</span>');
                            $('button[type="submit"]').prop('disabled', true);
                        }
                    });
                } else {
                    $('#usernameValidation').html('');
                    $('button[type="submit"]').prop('disabled', false);
                }
            });
            
            // Email validation
            $('#email').on('keyup', function () {
                var email = $(this).val();
                var regex = /^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/;
                
                if (email.length > 0) {
                    if (!regex.test(email)) {
                        $('#emailValidation').html('<span class="validation-message">Invalid email format!</span>');
                        $('button[type="submit"]').prop('disabled', true);
                    } else {
                        $.ajax({
                            type: 'POST',
                            url: '/GlowyDays/ValidateEmail',
                            data: { email: email, currentId: ${customer.id} },
                            success: function (response) {
                                if (response.trim() === "Available") {
                                    $('#emailValidation').html('<span class="valid-message">Valid email!</span>');
                                    $('button[type="submit"]').prop('disabled', false);
                                } else {
                                    $('#emailValidation').html('<span class="validation-message">Email is already in use.</span>');
                                    $('button[type="submit"]').prop('disabled', true);
                                }
                            },
                            error: function () {
                                $('#emailValidation').html('<span class="validation-message">Error validating email.</span>');
                                $('button[type="submit"]').prop('disabled', true);
                            }
                        });
                    }
                } else {
                    $('#emailValidation').html('');
                    $('button[type="submit"]').prop('disabled', false);
                }
            });
            
            // Phone number validation
            $('#mobileNo').on('keyup', function () {
                var phoneNumber = $(this).val();
                var regex = /^01[0-9]-[0-9]{7,10}$/;
                
                if (phoneNumber.length > 0) {
                    if (!regex.test(phoneNumber)) {
                        $('#phoneValidation').html('<span class="validation-message">Invalid phone format! Example: 012-3456789</span>');
                        $('button[type="submit"]').prop('disabled', true);
                    } else {
                        $('#phoneValidation').html('<span class="valid-message">Valid phone number!</span>');
                        $('button[type="submit"]').prop('disabled', false);
                    }
                } else {
                    $('#phoneValidation').html('');
                    $('button[type="submit"]').prop('disabled', false);
                }
            });
            
            // Password validation
            var myInput = document.getElementById("password");
            var letter = document.getElementById("letter");
            var capital = document.getElementById("capital");
            var number = document.getElementById("number");
            var length = document.getElementById("length");
            
            // When the user clicks on the password field, show the message box
            myInput.onfocus = function() {
                document.getElementById("passwordMessage").style.display = "block";
            }
            
            // When the user clicks outside of the password field, hide the message box
            myInput.onblur = function() {
                document.getElementById("passwordMessage").style.display = "none";
            }
            
            // When the user starts to type something inside the password field
            myInput.onkeyup = function() {
                // Validate lowercase letters
                var lowerCaseLetters = /[a-z]/g;
                if(myInput.value.match(lowerCaseLetters)) {
                    letter.classList.remove("invalid");
                    letter.classList.add("valid");
                    letter.innerHTML = "✓ A <b>lowercase</b> letter";
                } else {
                    letter.classList.remove("valid");
                    letter.classList.add("invalid");
                    letter.innerHTML = "✖ A <b>lowercase</b> letter";
                }
                
                // Validate capital letters
                var upperCaseLetters = /[A-Z]/g;
                if(myInput.value.match(upperCaseLetters)) {
                    capital.classList.remove("invalid");
                    capital.classList.add("valid");
                    capital.innerHTML = "✓ A <b>capital (uppercase)</b> letter";
                } else {
                    capital.classList.remove("valid");
                    capital.classList.add("invalid");
                    capital.innerHTML = "✖ A <b>capital (uppercase)</b> letter";
                }
                
                // Validate numbers
                var numbers = /[0-9]/g;
                if(myInput.value.match(numbers)) {
                    number.classList.remove("invalid");
                    number.classList.add("valid");
                    number.innerHTML = "✓ A <b>number</b>";
                } else {
                    number.classList.remove("valid");
                    number.classList.add("invalid");
                    number.innerHTML = "✖ A <b>number</b>";
                }
                
                // Validate length
                if(myInput.value.length >= 8) {
                    length.classList.remove("invalid");
                    length.classList.add("valid");
                    length.innerHTML = "✓ Minimum <b>8 characters</b>";
                } else {
                    length.classList.remove("valid");
                    length.classList.add("invalid");
                    length.innerHTML = "✖ Minimum <b>8 characters</b>";
                }
            }
            
            // Birth date validation - ensure user is at least 18 years old
            $('#birth').on('change', function() {
                var birthDate = new Date($(this).val());
                var today = new Date();
                var age = today.getFullYear() - birthDate.getFullYear();
                var m = today.getMonth() - birthDate.getMonth();
                
                if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
                    age--;
                }
                
                if (age < 18) {
                    $('#birthValidation').html('<span class="validation-message">You must be at least 18 years old.</span>');
                    $('button[type="submit"]').prop('disabled', true);
                } else {
                    $('#birthValidation').html('<span class="valid-message">Valid age!</span>');
                    $('button[type="submit"]').prop('disabled', false);
                }
            });
            
            // Form submission
            $('#editForm').submit(function(e) {
                // Additional form validation can be added here if needed
                return true;
            });
            
            // Auto-hide notifications after 5 seconds
            setTimeout(function() {
                $(".notification").fadeOut("slow");
            }, 5000);
        });
    </script>
</body>
</html>

//
Finishing the JavaScript validation functions:

1.  Added username validation to check availability
    Added email validation with format checking and availability check
    Added phone number validation with pattern matching
    Completed the interactive password validation
    Added birth date validation to ensure users are at least 18 years old


2.  Added the form submission handler

3.  Added notification support for displaying success/error messages

4. Included comprehensive validation for all fields that:
    Checks format validity (regex patterns)
    Makes AJAX calls to server for validation when needed
    Provides real-time feedback to users
    Disables/enables the submit button based on validation results


5. Added interactive password validation with visual indicators that show:
    If the password contains lowercase letters
    If the password contains uppercase letters
    If the password contains numbers
    If the password meets minimum length requirements