*** Settings ***
Library    Browser
Library    OperatingSystem
Library    String
Resource    recipes.robot

*** Keywords ***
Initialize Shopping List File
    [Documentation]    Create a blank shopping list text file. This is used by the keyword Add Products To A Shopping List.
    ...    Products added here can later be added to the shopping cart by calling keyword Order Shopping List.
    Create File    shopping_list.txt    content=    encoding=UTF-8

Add Products
    [Arguments]    ${searched_product}    ${number_of_products}=1
    [Documentation]    Searches for the product, which is passed to the keyword as an argument. Adds desired number of product to the cart.
    Sleep    1s
    Type Text    //div[@class='product-search-input-container']//input    ${searched_product}
    Sleep    2s
    Click    //div[@class='search-toggle']
    Click    //div[contains(@class,'product-result-item')]//a[contains(@title,"${searched_product}")]
    Repeat Keyword    ${number_of_products}    Click    //div[@class='amount-controls active']//button[@title='Lisää']
    Click    //div[@class='modal__close']

Add Products To A Shopping List
    [Arguments]    ${searched_product}    ${number_of_products}=1
    [Documentation]    Adds the desired number of products to the shopping cart file. This can be later triggered to order the procuts by using the keyword Order Shopping List.
    ...    A line in the file contains the product, a comma as a separator and the number of products, with the default value of one.
    ...    Lastly, a line break is added.
    Append To File    shopping_list.txt    ${searched_product},${number_of_products}\n

Order Shopping List
    [Documentation]    Adds products from the shopping cart file to the cart.
    #Read the file contents into a variable
    ${shopping_list_contents}=    Get File    shopping_list.txt    encoding=UTF-8
    #Break the variable down into lines
    @{lines}    Split To Lines    ${shopping_list_contents}
    #Loop through the lines and trigger keyword Add Products with appropriate amounts of products
    FOR    ${line}    IN    @{lines}
        ${product}    Split String    ${line}    ,
        Add Products    ${product}[0]    ${product}[1]
    END

Include Recipe
    [Arguments]    ${name_of_recipe}    ${multiplication}
    [Documentation]    Adds ingredients of the desired recipe to the cart. Multiplication argument can be used to add products several times.
    Sleep    1s
    Repeat Keyword    ${multiplication}    Run Keyword    ${name_of_recipe}

Report Price
    [Documentation]    Displays the current price of cart in text. Use this to log the price in the RF result files.
    ${current_price}    Get Text    //div[@class='total-price']
    Log    Ostoskorin hinta: ${current_price} euroa.