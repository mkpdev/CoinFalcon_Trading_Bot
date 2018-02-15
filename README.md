# README

### Version : 

- Ruby Version - 2.3.1
- Rails Version - 5.1.4
- Database (development) - sqlite3
- Database (production) - postgres

### Clone :

https://github.com/mkpdev/CoinFalcon_Trading_Bot.git

### Set-up Database :

- run `rake db:create`
- run `rake db:migrate`
- run `rake db:seed`

### Secret Key :

set Client `Key` and `Secret` in `config/application.yml`

### Description :

- Home Page : Here we have Client's `Transfer history` or `My order` and pending Trade that need to be placed after market update.
This is auto-update page, its update interval is `40 seconds`.
Once client criteria is full filled (for ex :- x% lower in Buy price or y% higher in sell price), order is automatically placed in market.

- Create Trade - 
    1. Choose type (Buy order or sell order)
    2. Choose market
    3. Number of order you want to place for buy or sell.
    4. How much change in price (percentage) when you want to place your order.
    5. Size of your order.
    
### Logic :

  After every `40 seconds` Order-book is update and check your Trade that you plcaed (Create Trade).
  If current market price change is equal (or greater/lower) to your Trade price (Change in Price) than
  your order is automatically placed in market.

### Heroku :

  https://afternoon-earth-14571.herokuapp.com/

