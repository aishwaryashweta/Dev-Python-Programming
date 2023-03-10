# Create Temperature objects
from temprature import Temperature

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