import json
from pathlib import Path

DATA_FILE = Path(__file__).with_name("members.json")


def load_members():
    """Load members list from `members.json`. Returns a list of member objects.

    If the file doesn't exist or can't be parsed, returns an empty list.
    """
    if not DATA_FILE.exists():
        return []
    try:
        with DATA_FILE.open("r", encoding="utf-8") as f:
            return json.load(f)
    except Exception:
        return []


def save_members(members):
    """Write the members list back to `members.json`."""
    with DATA_FILE.open("w", encoding="utf-8") as f:
        json.dump(members, f, indent=2, ensure_ascii=False)


def print_members(members):
    """Print each member on its own line."""
    if not members:
        print("No members found.")
        return

    print(*members, sep='\n')


def new_member_append_strings():
    """Ask for name/email, append a member object, and persist to file.

    Members are stored as objects like {"name": "Salah", "email": "..."}.
    """
    members = load_members()
    name = input("Enter your name: ").strip()
    email = input("Enter your email: ").strip()
    member = {"name": name, "email": email}
    members.append(member)
    save_members(members)
    print("Appended member:", member)
    print(f"Total members: {len(members)}")
    print_members(members)
    return members


if __name__ == "__main__":
    new_member_append_strings()
