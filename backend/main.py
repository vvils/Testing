import random
import string
from datetime import datetime

def generate_random_string(length=10):
    """Generate a random string of specified length"""
    letters = string.ascii_letters + string.digits
    return ''.join(random.choice(letters) for i in range(length))

def generate_random_number(min_val=1, max_val=100):
    """Generate a random number within specified range"""
    return random.randint(min_val, max_val)

def get_current_timestamp():
    """Get current timestamp in ISO format"""
    return datetime.now().isoformat()

def random_choice_from_list(items):
    """Return a random item from a list"""
    if not items:
        return None
    return random.choice(items)

if __name__ == "__main__":
    print("Backend Service Started")
    print(f"Random String: {generate_random_string()}")
    print(f"Random Number: {generate_random_number()}")
    print(f"Current Time: {get_current_timestamp()}")
    
    sample_items = ["apple", "banana", "cherry", "date", "elderberry"]
    print(f"Random Choice: {random_choice_from_list(sample_items)}")