*** Settings ***
Library           SeleniumLibrary
Suite Setup       Open Register Browser
Suite Teardown    Close Browser

*** Variables ***
${URL}            http://localhost:3000/register
${BROWSER}        Chrome

*** Test Cases ***
User registers with an account number shorter than 10 digits should return an account ID error
    [Documentation]    EQ41, EQ2, EQ31
    Register User    1234    1234    Test    User
    Page Should Contain    Your account ID must be exactly 10 digits long

User registers with an account number longer than 10 digits should return an account ID error
    [Documentation]    EQ42, EQ2, EQ32
    Register User    1234567890000    1234    chaveehandsomeandcool    handsome
    Page Should Contain    Your account ID must be exactly 10 digits long

User registers with a non-digit account number should return an account ID error
    [Documentation]    EQ5, EQ2, EQ31
    Register User    eiei123456    1234    Test    User
    Page Should Contain    Your account ID should contain numbers only

User registers with an existing account number should return an already in use error
    [Documentation]    EQ6, EQ2, EQ32
    Register User    1234567890    1234    chaveehandsomeandcool    handsome
    Page Should Contain    This account ID is already in use. Please choose another.

User registers with a non-digit password should return a password error
    [Documentation]    EQ1, EQ9, EQ31
    Register User    1234567890    eiei    Test    User
    Page Should Contain    Your password should contain numbers only.

User registers with a password shorter than 4 digits should return a password error
    [Documentation]    EQ1, EQ81, EQ32
    Register User    1234567890    1    chaveehandsomeandcool    handsome
    Page Should Contain    Your password must be exactly 4 digits long.

User registers with a password longer than 4 digits should return a password error
    [Documentation]    EQ1, EQ82, EQ31
    Register User    1234567890    12345678    Test    User
    Page Should Contain    Your password must be exactly 4 digits long.

User registers with a full name longer than 30 characters (including space) should return a fullname error
    [Documentation]    EQ1, EQ2, EQ12
    Register User    1234567890    1234    chaveehandsomeandcool    coolandhandsome
    Page Should Contain    Your fullname must be 30 characters or less, including spaces.

*** Keywords ***
Open Register Browser
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window

Register User
    [Arguments]    ${account}    ${password}    ${firstname}    ${lastname}
    Go To    ${URL}

    Input Text    xpath=//input[@placeholder="Please fill your account number (10 digits)"]    ${account}
    Input Text    xpath=//input[@placeholder="Please fill your password (4 digits)"]           ${password}
    Input Text    xpath=//input[@placeholder="Please fill your first name"]                    ${firstname}
    Input Text    xpath=//input[@placeholder="Please fill your last name"]                     ${lastname}

    Click Button   xpath=//button[text()="Register"]

    Sleep    1s
    Capture Page Screenshot
