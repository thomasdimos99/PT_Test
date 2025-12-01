import os
import sys
import csv
import requests

def main():
    if len(sys.argv) < 2:
        print("output.csv")
        sys.exit(1)

    org = sys.argv[1]
    output_file = sys.argv[2] if len(sys.argv) > 2 else "org_repos.csv"

    token = os.getenv("GITHUB_TOKEN")
    if not token:
        print("Error, token is missing")
        sys.exit(1)

    headers = {
        "Authorization": f"Bearer {token}",
        "Accept": "application/vnd.github+json"
    }

    url = f"https://api.github.com/orgs/{org}/repos"
    params = {"per_page": 100}
    all_rows = []

    while url:
        resp = requests.get(url, headers=headers, params=params)
        resp.raise_for_status()

        repos = resp.json()
        for repo in repos:
            name = repo.get("name", "")
            full_name = repo.get("full_name", "")
            repo_id = repo.get("id", "")
            all_rows.append([name, full_name, repo_id])

        if "next" in resp.links:
            url = resp.links["next"]["url"]
            params = None
        else:
            url = None

    with open(output_file, "w", newline="", encoding="utf-8") as f:
        writer = csv.writer(f, delimiter=";")
        writer.writerows(all_rows)

    print(f"Found {len(all_rows)} repos. Saved to {output_file}")


if __name__ == "__main__":
    main()