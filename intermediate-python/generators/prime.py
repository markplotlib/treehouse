# source: https://jeffknupp.com/blog/2013/04/07/improve-your-python-yield-and-generators-explained/


def get_primes(input_list):
    result_list = list()
    for element in input_list:
        if is_prime(element):
            result_list.append()

    return result_list

# or better yet...

# def get_primes(input_list):
#     return (element for element in input_list if is_prime(element))


def is_prime(number):
    if number > 1:
        if number == 2:
            return True
        if number % 2 == 0:
            return False
        for current in range(3, int(math.sqrt(number) + 1), 2):
            if number % current == 0: 
                return False
        return True
    return False

