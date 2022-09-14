There are many different units in which temperature can be measured. Three of the most common are Celsius,  Fahrenheit, and Kelvin (used a lot in science).

Your task is to define a Temperature class, which we can use to more easily convert temperatures from one scale to another, and to compare temperatures that are on different scales.

The conversions between the scales go as follows:

## Converting to Celcius:
> Celcius = (Fahrenheit - 32) × 5/9
> 
> Celcius = Kelvin - 273.15

## Converting from Celcius:
> Fahrenheit = (9/5 x Celcius) + 32
> 
> Kelvin = Celcius + 273.15

As a guide, use the Length class that was defined in one of this week's illustrative examples.

Your Temperature class should:

Have an __init__ special method that allows you to create a Temperature object by supplying a number and a unit: either Celcius (C), Fahrenheit (F), or Kelvin (K).

Have a __str__ special method that allows you to print a Temperature object in an informative way.

Have an instance method called to that has a parameter for a unit, an optional parameter for a number of decimal places, and returns the temperature of the instance in the given unit, rounded to the given number of decimal places, if any were given, otherwise not rounded.

Have __eq__, __lt__, __le__, __gt__, and __ge__ special methods that allow you to compare two Temperature objects.

Save your class in a module called temperature.py. Import this module into code.py, and add some code to code.py that illustrates the use of your Temperature class.

Example:

Here is the kind of code you might use in code.py to illustrate your class:

# Create Temperature objects
temp_1 = Temperature(32, 'C')
temp_2 = Temperature(100, 'F')
temp_3 = Temperature(324, 'K')

# Print them

print(temp_1) # Outputs Temperature: 32C
print(temp_2) # Outputs Temperature: 100F
print(temp_3) # Outputs Temperature: 324K

# Convert them
print(temp_1.to('F')) # Outputs 89.6
print(temp_2.to('K', 3)) # Outputs 310.928
print(temp_3.to('C', 1)) # Outputs 50.9

# Compare them
print(temp_1 == temp_2) # Outputs False
print(temp_1 < temp_2) # Outputs True
print(temp_1 <= temp_2) # Outputs True
print(temp_1 > temp_2) # Outputs False
print(temp_1 >= temp_2) # Outputs False