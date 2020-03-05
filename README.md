# ILL Billing System

[![Code Climate](https://codeclimate.com/repos/559aaef8e30ba06bfd0001d9/badges/c7609d3879a4d9b01db0/gpa.svg)](https://codeclimate.com/repos/559aaef8e30ba06bfd0001d9/feed) [![Test Coverage](https://codeclimate.com/repos/559aaef8e30ba06bfd0001d9/badges/c7609d3879a4d9b01db0/coverage.svg)](https://codeclimate.com/repos/559aaef8e30ba06bfd0001d9/coverage) [![Dependency Status](https://gemnasium.com/ucsdlib/billing-ill.svg)](https://gemnasium.com/ucsdlib/billing-ill)

ILL Billing System is a Ruby on Rails web application which is created for processing and invoicing the Receivables, UCSD Recharges, UC Recharges, and Payables from the Interlibrary Loan Services in [UC San Diego Library](http://libraries.ucsd.edu/ "UC San Diego Library")

## Requirements

* Ruby 2.2.3+
* git

## Installation

```
$ git@github.com:ucsdlib/billing-ill.git
```

## Usage

1.Open project.

```
$ cd billing-ill
```

2.Checkout develop branch.

```
$ git checkout develop
```

3.Copy DB Sample.

```
$ cp config/database.yml.example config/database.yml
```

4.Copy and edit Secrets Sample.
Replace the secret_key_base hex string with a new random string (you can generate a new random key with rake secret).

```
$ cp config/secrets.yml.example config/secrets.yml
```

5.Update DB.

```
$ bundle exec rake db:migrate
```

## Running ILL Billing

* WEBrick

```
$ rails s
```

## ILL Billing will be available at

```
http://localhost:3000
```

## Running the Test Suites

```
$ bundle exec rake
$ rubocop
```

## Docs
Various reference documents for this application can be found in the `doc`
folder in this repository.
