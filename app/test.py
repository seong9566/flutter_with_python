import os
def sum_numbers():
    total = 0
    for i in range(1, 11):
        total += i
    return total

result = sum_numbers()
print("1부터 10까지의 합:", result)

result_filename = os.getenv("RESULT_FILENAME")
with open(result_filename, "w") as f:
    f.write(str(result))