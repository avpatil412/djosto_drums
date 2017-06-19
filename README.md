**Wizergos Chanllenge**

Website - http://drums.dojosto.com

Automate an angular app which plays different rhythms passed in as parameters. From launching the app to playing a custom rhythm.
 
Demo the various framework concept which you are aware of like Page factory, domain builders etc.

Use any IDE as per your convenience. 


**Approach** 

The solution to the above problem statement has been provided as a UI Test Automation FW.

Built on rspec, ruby with rails support.

Notable Open Source Libraries used:

1. SitePrism
2. Capybara


To the run the FW locally, the system must be running on Ruby -v 2.3.1 with rvm and rails(4.2.7 and above) support. 


**Configuration To run locally**

1. Once on the root directory of the project, run the command `cd .`(Ensure you have rvm installed on your system).

    This will create a disposable gemset which won't mess up the default gemset of the system. This has been automated using the .rvmrc file.
    
    This file will produce a trust issue on bash and it is absolutely fine to trust the .rvmrc file.
2. Run `gem install bundler -v 1.12.5` from the root directory of project
3. Run `bundle install` from the root directory of project
4. All the rhythm patterns are present in `spec/config/rhythm_library.yml`
5. Run the all test scripts at once with the following command from the root directory of project.

    `bundle exec rspec spec/features/rhythms/*.rb --format h > drums_dojosto_report.html`
    
    The above command would give the output of the tests in an html format and the output will be present in the root directory of project 
6. The framework supports 3 browsers (chrome, firefox and safari). To select any browser run tests with following command:

    `JS_DRIVER="selenium-safari" bundle exec rspec spec/features/rhythms/rhythms.rb`
    
    `JS_DRIVER="selenium-chrome" bundle exec rspec spec/features/rhythms/rhythms.rb`
    
    `JS_DRIVER="selenium-firefox" bundle exec rspec spec/features/rhythms/rhythms.rb`
    
   If the environment variable (ENV[JS_DRIVER]) is not set, chrome will be used as default browser.
7. The FW has been configured to take screenshots on failures and will be stored in `spec/screenshots` folder in image and html format.

    However they have been limited to store 20 screenshots at time. If the count increases, the folder will be successively cleared.
    
    Keeping the screenshots for the last 20 failures at any given point of time.
8. The `spec/page_object` folder contains the page_objects for the various page and partials used in the scripts. 

    This is scalable and new page_objects can be added without any other code changes to the existing FW.
9. The `spec/support/helpers` folder contains helper files which contain re-usable methods which may be used for other tests.

    The methods provided here have optional parameters which make it flexible to fit into major workflows.
10. A generic Rakefile has been provided which can be scaled up so that the FW can be deployed on CI/CD environments.
# djosto_drums
