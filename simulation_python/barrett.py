def barrett_multiplication(a, b, n):
    """
    Perform modular multiplication using Barrett Reduction.

    Args:
    a (int): First operand
    b (int): Second operand
    n (int): Modulus

    Returns:
    int: Result of (a * b) % n
    """
    # Precompute mu = floor(2^k / n), where k is the bit-length of n multiplied by 2
    k = n.bit_length() * 2
    mu = (1 << k) // n  # Equivalent to 2^k // n

    # Step 1: Compute the product
    c = a * b

    # Step 2: Compute q = floor(c * mu / 2^k)
    q = (c * mu) >> k

    # Step 3: Compute r = c - q * n
    r = c - q * n

    # Step 4: If r >= n, subtract n to ensure r < n
    if r >= n:
        r -= n

    return r

# Example usage
a = 5792
b = 1229
n = 72639

result = barrett_multiplication(a, b, n)
print(f"The result of ({a} * {b}) % {n} is {result}")
