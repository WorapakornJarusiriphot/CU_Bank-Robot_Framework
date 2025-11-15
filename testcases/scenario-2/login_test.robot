*** Settings ***
Library           SeleniumLibrary
Suite Setup    Open Login Browser
Suite Teardown    Close Browser
Test Setup    Clear Login Form

*** Variables ***
${URL}            http://localhost:3000/
${BROWSER}        Chrome

*** Test Cases ***
User login with a non-digit account number should return an account ID error
    [Documentation]    EQ5, EQ2
    Login User    eiei123456    1234
    Page Should Contain    Your account ID should contain numbers only.

User login with an account number shorter than 10 digits should return an account ID error
    [Documentation]    EQ41, EQ2
    Login User    1234    1234
    Page Should Contain    Your account ID must be exactly 10 digits long.

User login with an account number longer than 10 digits should return an account ID error
    [Documentation]    EQ42, EQ2
    Login User    1234567890000    1234
    Page Should Contain    Your account ID must be exactly 10 digits long.

User login with non-existing account number should return not found error
    [Documentation]    EQ7, EQ2
    Login User    0123456781    1234
    Page Should Contain    User not found. Please check your account ID.

User login with a non-digit password should return a password error
    [Documentation]    EQ6, EQ9
    Login User    1234567890    eiei
    Page Should Contain    Your password should contain numbers only.

User login with a password shorter than 4 digits should return a password error
    [Documentation]    EQ6, EQ81
    Login User    1234567890    1
    Page Should Contain    Your password must be exactly 4 digits long.

User login with a password longer than 4 digits should return a password error
    [Documentation]    EQ6, EQ82
    Login User    1234567890    12345678
    Page Should Contain    Your password must be exactly 4 digits long.

User login with non-matching password should return incorrect password error
    [Documentation]    EQ6, EQ10
    Login User    1234567890    4321
    Page Should Contain    Incorrect password. Please try again.

*** Keywords ***
Open Login Browser
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window

Clear Login Form
    Wait Until Element Is Visible    xpath=//input[@placeholder="Please fill your account number (10 digits)"]
    Clear Element Text    xpath=//input[@placeholder="Please fill your account number (10 digits)"]
    Clear Element Text    xpath=//input[@placeholder="Please fill your password (4 digits)"]

Login User
    [Arguments]    ${account}    ${password}
    Input Text    xpath=//input[@placeholder="Please fill your account number (10 digits)"]    ${account}
    Input Text    xpath=//input[@placeholder="Please fill your password (4 digits)"]           ${password}
    Click Button    xpath=//button[text()="Login"]
    Sleep    1s
    Capture Page Screenshot
