class Temperature:

    def __init__(self, number, unit):
        self.number = number
        self.unit = unit
        self.out = None

    def __str__(self):
        return "Outputs Temperature: {}{}".format(self.number, self.unit)

    def to(self, temp, round_of=None):

        if self.unit == "K" and temp == "C":
            self.out = self.number - 273.15

        elif self.unit == "F" and temp == "C":
            self.out = (self.number - 32) * 5 / 9

        elif self.unit == "C" and temp == "F":
            self.out = (9 / 5 * self.number) + 32

        elif self.unit == "C" and temp == "K":
            self.out = self.number + 273.15

        elif self.unit == "F" and temp == "K":
            self.out = (self.number - 32) * 5 / 9 + 273.15

        if round_of is None:
            return self.out
        else:
            return round(self.out, round_of)

    def __eq__(self, other):
        return self.out == other.out

    def __gt__(self, other):

        if self.out > other.out:
            return True
        else:
            return False

    def __lt__(self, other):

        if self.out < other.out:
            return True
        else:
            return False

    # return comparison
    def __le__(self, other):
        if self.out <= other.out:
            return True
        else:
            return False

    # return comparison
    def __ne__(self, other):
        if self.out != other.out:
            return True
        else:
            return False

    # return comparison
    def __ge__(self, other):

        if self.out >= other.out:
            return True
        else:
            return False
