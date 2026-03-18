import random

def generate_n_bit_random_number(n):
    """
    Generate an n-bit random number.

    Args:
    n (int): Number of bits.

    Returns:
    int: A random n-bit number.
    """
    if n <= 0:
        raise ValueError("Number of bits must be a positive integer.")
    
    # Generate a random number in the range [2^(n-1), 2^n - 1]
    lower_bound = 1 << (n - 1)  # Equivalent to 2^(n-1)
    upper_bound = (1 << n) - 1  # Equivalent to 2^n - 1
    
    return random.randint(lower_bound, upper_bound)


#print(f"{n}-bit random number: {random_number}")
def barrett_multiplication_wordwise(a, b, n, l, w):
    """
    Perform modular multiplication using Barrett Reduction in a wordwise manner.

    Args:
    a (int): First operand (e.g., 16 bits)
    b (int): Second operand (e.g., 16 bits)
    n (int): Modulus
    w (int): Number of bits to process at a time (e.g., 4 bits)

    Returns:
    int: Result of (a * b) % n
    """
    # Precompute mu = floor(2^k / n), where k is the bit-length of n multiplied by 2
    #k = n.bit_length() * 2
    k = l * 2
    mu = (1 << k) // n  # Equivalent to 2^k // n
    print(f"mu: {mu}")
    # Break `a` and `b` into chunks of `w` bits
    num_chunks = l // w
    #if a.bit_length() % w != 0:
    #    num_chunks += 1  # Add an extra chunk for remainder bits

    # Initialize result
    result = 0

    # Iterate through chunks of `a`
    for i in range(num_chunks):
        aw = (a >> (i * w)) & ((1 << w) - 1)
        print(f"aw: {aw}, {i}")
        # Iterate through chunks of `b`
        for j in range(num_chunks):
            print(f"-----------i:{i}, j:{j}---------------")
            bw = (b >> (j * w)) & ((1 << w) - 1)

            # Step 1: Compute the product for the current chunks
            c = aw * bw
            print(f"c:{c}")
            # Align the result by shifting according to the chunk positions
            c <<= (i + j) * w  #c_shift
            print(f"c shift:{c} and k:{k}")
            # Step 2: Compute q = floor(c * mu / 2^k) (Barrett pre-reduction)
            q = (c * mu) >> k
            print(f"Q:{q}")
            # Step 3: Compute r = c - q * n
            r = c - q * n
            
            # Step 4: Reduce r modulo n if necessary
            '''if r >= n:
                r -= n
            #elif r < 0:  # Handle negative values
            #    r += n
            print(f"R2:{r}")
            # Accumulate the reduced result
            result += r'''
            # Reduce r modulo n and accumulate the result
            if r >= n:
                result = result + r - n
            else:
                result = result + r  # Just add r if it's already less than n
            print(f"R2:{r}")
            # Reduce the accumulated result modulo n
            if result >= n:
                result -= n
            print(f"result:{result}")

    return result


# Example usage
#a = 5792  # 16-bit operand
#b = 1229  # 16-bit operand
n = 72639  # Modulus
#n = 3329  # Modulus
l=20
w=4
for i in range(1):
    #a=generate_n_bit_random_number(16)
    #b=generate_n_bit_random_number(16)
    a = 5792  # 16-bit operand
    b = 1229  # 16-bit operand
    result = barrett_multiplication_wordwise(a, b, n, l, w)
    result1= (a*b) % n
    print(f"The result from barrett ({a} * {b}) % {n} is {result}")
    #print(f"The result of ({a} * {b}) % {n} is {(a*b) % n}")
    if(result!=result1):
     print("not matched")
    else:
     print("matched")
    
