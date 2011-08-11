# GoodMock #

This is a super simple mocking framework that checks to see that the object you are trying to mock really behaves in the way you are trying to mock it. Right now it is just a proof of concept. To be really useful it will need to only run the verification of the mocks once, and store the results.

## An example usage ##


    class Food
      def eat
        "tasty!!"
      end
    end
    
    m = GoodMock.new(Food)
    m.mock(:eat){"bleck"}
    puts m.eat
    
    begin
      m.strict_mock(:eat){9}
    rescue BadMockError => e
      puts ":eat got us #{e.message}"
    end
    
    begin
      m.mock(:drink){"gulp"}
    rescue BadMockError => e
      puts ":drink got us #{e.message}"
    end