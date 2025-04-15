<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="model.User" %>
<jsp:useBean id="user" class="model.User" scope="session" />
<jsp:setProperty name="user" property="name" param="name" />
<jsp:setProperty name="user" property="username" param="username" />
<jsp:setProperty name="user" property="birth" param="birth" />
<jsp:setProperty name="user" property="email" param="email" />
<jsp:setProperty name="user" property="mobileNo" param="mobileNo" />
<jsp:setProperty name="user" property="password" param="password" />

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Register</title>
        <link href="../CSS/register.css" rel="stylesheet" type="text/css">
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    </head>
    <body>
        <section id="header">
            <div class="header-left">
                <a href="../JSP/GuestHome.jsp"><img src="../IMG/logo.jpg" alt="Index" width="180" height="70"></a>
            </div>
            <div class="header-right">
                <input type="text" placeholder="Search.."><img src="../ICON/search.svg" width="30" height="30">
                <a href="../JSP/cart.jsp"><img src="../ICON/cart.svg" alt="Cart" width="45" height="45"></a>
                <a href="../JSP/Register.jsp"><img src="../ICON/avatar.svg" alt="Login" width="40" height="40"></a>
            </div>
        </section>

        <div id="signup">
            <br />
            <h1>Sign Up</h1>
            <%
                String errorMessage = (String) request.getAttribute("errorMessage");
                if (errorMessage != null && !errorMessage.isEmpty()) {
            %>
            
            <div class="error-message" style="color: red; text-align: center; margin: 10px 0;">
                <%= errorMessage%>
            </div>
            
            <%
                }
            %>
            <hr>

            <form action="/GlowyDays/UserRegistration" method="post">
                <fieldset>
                    <div class="label">
                        <label for="name">Full Name:</label>
                    </div>
                    <div class="input">
                        <input type="text" id="name" name="name" placeholder="Full Name" required>
                        <div id="nameValidation"></div>
                    </div>

                    <div class="label">
                        <label for="username">Username:</label>
                    </div>
                    <div class="input">
                        <input type="text" id="username" name="username" placeholder="Username" required><br/> 
                        <span class="red-text accent-4" id="usernameValidation"></span>
                    </div>

                    <div class="label">
                        <label for="birthday">Birth date:</label>
                    </div>
                    <div class="input">
                        <input type="date" id="birth" name="birth" required><br/>    
                        <span id="birthValidation"></span>
                    </div>

                    <div class="label">
                        <label for="emailInput">Email:</label>
                    </div>
                    <div class="input">
                        <input type="email" id="email" name="email" placeholder="Email" required><br/>   
                        <div id="emailValidation"></div>
                    </div>

                    <div class="label">
                        <label for="phoneInput">Mobile Number:</label>
                    </div>
                    <div class="input">
                        <input type="tel" id="mobileNo" name="mobileNo" pattern="01[0-9]-[0-9]{7,10}" placeholder="Mobile Number (01x-xxxxxxx)" required><br/>    
                        <span class="red-text accent-4" id="phoneValidation"></span>
                    </div>

                    <div class="label">
                        <label for="passwordInput">Password:</label>
                    </div>
                    <div class="input">
                        <input type="password" id="passwordInput" name="password" placeholder="Password" 
                               pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}" required><br/>    
                        <div id="passwordMessage" style="display: none;">
                            <h3 style="font-size: 15px;">Password must contain the following:</h3>
                            <p id="letter" class="invalid" style="font-size: 13px;">✖ A <b>lowercase</b> letter</p>
                            <p id="capital" class="invalid" style="font-size: 13px;">✖ A <b>capital (uppercase)</b> letter</p>
                            <p id="number" class="invalid" style="font-size: 13px;">✖ A <b>number</b></p>
                            <p id="length" class="invalid" style="font-size: 13px;">✖ Minimum <b>8 characters</b></p>
                        </div>
                    </div>

                    <div class="label">
                        <label for="CpasswordInput">Confirm Password:</label>
                    </div>
                    <div class="input">
                        <input type="password" id="CpasswordInput" name="Cpassword" placeholder="Confirm Password" 
                               pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}" required><br/>    
                        <div id="CpasswordMessage" style="display: none;">
                            <span class="CpasswordMessage"></span>
                        </div>
                        <br />
                        <br />
                    </div>

                    <div class="login-home" style="text-align:center">
                        <p>Already have an account? <a href="../JSP/Login.jsp">Login Now</a></p>
                    </div>

                    <button type="reset" 
                            style="border-radius:4px; background-color: rgb(253, 253, 214); color: black;
                            font-size: 15px; padding: 12px 20px; border: none; float:left;"
                            onmouseover="this.style.backgroundColor = 'black'; this.style.color = 'rgb(253, 253, 214)';"
                            onmouseout="this.style.backgroundColor = 'rgb(253, 253, 214)'; this.style.color = 'black';">
                        Reset
                    </button>

                    <button type="submit">Register</button>
                </fieldset>
            </form>
        </div>

        <!-- Full name validation (No special character)-->
        <script>
            $(document).ready(function () {
                $('#name').on('keyup', function () {
                    var fullName = $(this).val();
                    var regex = /^[A-Za-z\s/]+$/; // Only letters, spaces, and '/'

                    if (fullName.length > 0) { // Only check if there's input
                        if (!regex.test(fullName)) {
                            $('#nameValidation').html('<span style="color:red; font-size:13px;">Invalid characters detected! Only alphabets, spaces, and "/" are allowed.</span>');
                            $('button[type="submit"]').prop('disabled', true);
                        } else {
                            $.ajax({
                                type: 'POST',
                                url: '/GlowyDays/ValidateName', // Calls the servlet
                                data: {name: fullName},
                                success: function (response) { // Renamed for clarity
                                    if (response.trim() === "Valid Name") {
                                        $('#nameValidation').html('<span style="color:green; font-size:13px;">Valid Name!</span>');
                                        $('button[type="submit"]').prop('disabled', false);
                                    } else {
                                        $('#nameValidation').html('<span style="color:red; font-size:13px;">Invalid Name.</span>');
                                        $('button[type="submit"]').prop('disabled', true);
                                    }
                                },
                                error: function () {
                                    $('#nameValidation').html('<span style="color:red;">Error validating name.</span>');
                                    $('button[type="submit"]').prop('disabled', true);
                                }
                            });
                        }
                    } else {
                        $('#nameValidation').html(''); // Clear validation message
                        $('button[type="submit"]').prop('disabled', true); // Ensure form is disabled
                    }
                });
            });
        </script>
        <!-- End of Full name validation (No special character)-->

        <!-- Username validation (No duplicate username)-->
        <script>
            $(document).ready(function () {
                $('#username').on('keyup', function () {
                    var username = $(this).val().trim(); // Trim whitespace
                    if (username.length > 0) { // Only check if there's input
                        $.ajax({
                            type: 'POST',
                            url: '/GlowyDays/CheckName',
                            data: {username: username},
                            success: function (response) { // Renamed for clarity
                                if (response.trim() === "Already Exists") {
                                    $('#usernameValidation').html('<span style="color:red; font-size:13px;">Username is already taken. Please choose another.</span>');
                                    $('button[type="submit"]').prop('disabled', true); // Disable the register button
                                } else {
                                    $('#usernameValidation').html('<span style="color:green; font-size:13px;">Username is available!</span>');
                                    $('button[type="submit"]').prop('disabled', false); // Enable the register button
                                }
                            },
                            error: function () {
                                $('#usernameValidation').html('<span style="color:red;">Error checking username.</span>');
                                $('button[type="submit"]').prop('disabled', true);
                            }
                        });
                    } else {
                        $('#usernameValidation').html(''); // Clear validation message
                        $('button[type="submit"]').prop('disabled', true); // Disable submit button if input is empty
                    }
                });
            });
        </script>
        <!-- End of Username validation (No duplicate username)-->

        <!-- Birth date validation (X smaller than 1990 && Larger than today's date)-->
        <script>
            $(document).ready(function () {
                $('#birth').on('input', function () {
                    var birthDate = $(this).val(); // Get input value
                    if (!birthDate) {
                        $('#birthValidation').html(''); // Clear error if empty
                        return;
                    }

                    var inputDate = new Date(birthDate);
                    var minDate = new Date("1990-01-01");
                    var maxDate = new Date();
                    maxDate.setHours(0, 0, 0, 0); // Remove time part

                    // Validate only when full date is entered
                    if (birthDate.length === 10) {
                        if (inputDate < minDate) {
                            $('#birthValidation').html('<span style="color:red; font-size:13px;">Invalid birth date. Must be after 01-01-1990!</span>');
                            $(this).val(""); // Clear invalid input
                        } else if (inputDate > maxDate) {
                            $('#birthValidation').html('<span style="color:red; font-size:13px;">Invalid birth date. Cannot be in the future!</span>');
                            $(this).val(""); // Clear invalid input
                        } else {
                            $('#birthValidation').html(''); // Clear error if valid
                        }
                    }
                });
            });
        </script>
        <!-- End of Birth date validation (X smaller than 1990 && Larger than today's date)-->

        <!-- Email validation (No duplicate email)-->
        <script>
            $(document).ready(function () {
                $('#email').on('keyup', function () {
                    var email = $(this).val().trim(); // Trim whitespace
                    var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/; // Regular expression for valid email format

                    if (email.length > 0) {
                        if (!emailRegex.test(email)) { // Invalid email format
                            $('#emailValidation').html('<span style="color:red; font-size:13px;">Invalid email format! Please enter a valid email address.</span>');
                            $('button[type="submit"]').prop('disabled', true);
                        } else { // Valid email format, check if it already exists
                            $.ajax({
                                type: 'POST',
                                url: '/GlowyDays/CheckEmail',
                                data: {email: email},
                                success: function (response) {
                                    if (response.trim() === "Already Exists") {
                                        $('#emailValidation').html('<span style="color:red; font-size:13px;">This email address has already been registered. Please use another email.</span>');
                                        $('button[type="submit"]').prop('disabled', true);
                                    } else {
                                        $('#emailValidation').html('<span style="color:green; font-size:13px;">Email is available!</span>');
                                        $('button[type="submit"]').prop('disabled', false);
                                    }
                                },
                                error: function () {
                                    $('#emailValidation').html('<span style="color:red;">Error checking email.</span>');
                                    $('button[type="submit"]').prop('disabled', true);
                                }
                            });
                        }
                    } else {
                        $('#emailValidation').html(''); // Clear validation message
                        $('button[type="submit"]').prop('disabled', true); // Disable submit button if input is empty
                    }
                });
            });
        </script>
        <!-- End of email validation (No duplicate email)-->

        <!-- Mobile No validation (No duplicate mobile no)-->
        <script>
            $(document).ready(function () {
                $('#mobileNo').on('keyup', function () {
                    var mobileNo = $(this).val().trim(); // Trim whitespace

                    // Mobile number pattern (Malaysian format: 01x-xxxxxxx)
                    var mobilePattern = /^01[0-9]-[0-9]{7,10}$/;

                    if (mobileNo.length > 0) {
                        if (!mobilePattern.test(mobileNo)) {
                            $('#phoneValidation').html('<span style="color:red; font-size:13px;">Invalid mobile number format. Use 01x-xxxxxxx.</span>');
                            $('button[type="submit"]').prop('disabled', true);
                            return;
                        }

                        // Perform AJAX request
                        $.ajax({
                            type: 'POST',
                            url: '/GlowyDays/CheckMobile',
                            data: {mobileNo: mobileNo},
                            success: function (response) {
                                if (response.trim() === "Already Exists") {
                                    $('#phoneValidation').html('<span style="color:red; font-size:13px;">Mobile Number is already taken. Please choose another.</span>');
                                    $('button[type="submit"]').prop('disabled', true);
                                } else {
                                    $('#phoneValidation').html('<span style="color:green; font-size:13px;">Mobile Number is available!</span>');
                                    $('button[type="submit"]').prop('disabled', false);
                                }
                            },
                            error: function () {
                                $('#phoneValidation').html('<span style="color:red;">Error checking mobile number.</span>');
                                $('button[type="submit"]').prop('disabled', true);
                            }
                        });
                    } else {
                        $('#phoneValidation').html(''); // Clear validation message
                        $('button[type="submit"]').prop('disabled', true);
                    }
                });
            });
        </script>
        <!-- End of Mobile No validation (No duplicate mobile no)-->

        <!-- Password validation (Meet with requirement)-->
        <script>
            $(document).ready(function () {
                $('#passwordInput').on('keyup', function () {
                    var password = $(this).val();

                    var hasLowerCase = /[a-z]/.test(password);
                    var hasUpperCase = /[A-Z]/.test(password);
                    var hasNumber = /[0-9]/.test(password);
                    var hasMinLength = password.length >= 8;

                    function updateValidation(element, isValid) {
                        if (isValid) {
                            $(element).removeClass("invalid").addClass("valid").text("✔ " + $(element).text().substring(2));
                        } else {
                            $(element).removeClass("valid").addClass("invalid").text("✖ " + $(element).text().substring(2));
                        }
                    }

                    updateValidation('#letter', hasLowerCase);
                    updateValidation('#capital', hasUpperCase);
                    updateValidation('#number', hasNumber);
                    updateValidation('#length', hasMinLength);

                    // Check server-side validation only if all conditions pass
                    if (hasLowerCase && hasUpperCase && hasNumber && hasMinLength) {
                        $.ajax({
                            type: 'POST',
                            url: '/GlowyDays/CheckPassword',
                            data: {password: password},
                            success: function (response) {
                                $('#passwordMessage span').remove(); // Remove previous messages
                                if (response.trim() !== "Valid") {
                                    $('#passwordMessage').append('<span style="color:red;">✖ ' + response + '</span>');
                                }
                            },
                            error: function () {
                                $('#passwordMessage span').remove();
                                $('#passwordMessage').append('<span style="color:red;">Error validating password.</span>');
                            }
                        });
                    }
                });

                // Show message box when focused
                $('#passwordInput').focus(function () {
                    $('#passwordMessage').show();
                });

                // Hide message box when input is empty
                $('#passwordInput').blur(function () {
                    if ($('#passwordInput').val() === '') {
                        $('#passwordMessage').hide();
                    }
                });
            });
        </script>
        <!-- End of Password validation (Meet with requirement)-->

        <!-- Confirm Password validation (Must same with Password text field)-->
        <script>
            $(document).ready(function () {
                function validatePassword() {
                    var password = $('#passwordInput').val();
                    var confirmPassword = $('#CpasswordInput').val();

                    if (confirmPassword.length > 0) {
                        $('#CpasswordMessage').show(); // Ensure the message box is visible

                        if (confirmPassword !== password) {
                            $('#CpasswordMessage').html('<span style="color:red; font-size:13px;">Please reenter the same password to confirm password!</span>');
                            $('button[type="submit"]').prop('disabled', true);
                        } else {
                            $('#CpasswordMessage').html('<span style="color:green; font-size:13px;">Passwords match.</span>');
                            $('button[type="submit"]').prop('disabled', false);
                        }
                    } else {
                        $('#CpasswordMessage').hide(); // Hide message if field is empty
                    }
                }

                // Run validation when either field changes
                $('#passwordInput, #CpasswordInput').on('keyup', validatePassword);
            });
        </script>
        <!-- End of Confirm Password validation (Must same with Password text field)-->

    </body>
</html>