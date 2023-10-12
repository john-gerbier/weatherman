# README

Things you may need to setup project:

* Ruby version 3.0.6

* Rails version 7.0.8

* Component Library from Tailwind + Flowbite https://flowbite.com/docs/getting-started/introduction/


### Setting up the development environment

1.  Get the code. Clone this git repository and check out the latest release:

    ```bash
    git clone https://github.com/
    cd WeatherMan
    ```

2.  Install the required gems by running the following command in the project root directory:

    ```bash
    bundle install
    ```

4.  You need to generate your api key for this `https://api.openweathermap.org/data/2.5/weather` and then place it in credentails.yml file like:

    `openweather_api_key: your_api_key`

3.  Precompile assets by running:
    ```bash
    rake assets:clobber
    bundle exec rails assets:precompile
    ```

6.  Run server:

    `rails s` or `bin/dev`

Congratulations! WeatherMan should now be up and running for development purposes on http://localhost:3000/


### Assumptions
- We used `openweathermap` and `openstreetmap` API's to fetch weather details and places because these are opensource.
- Google places and Google maps API's can be used for better results and speed.
- Geocoder is being used to generate cordinates of location.
- Results are being cached for 30 minutes on server side.