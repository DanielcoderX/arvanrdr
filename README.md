# ArvanCloud Internet Monitoring Dashboard

The ArvanCloud Internet Monitoring Dashboard is a Ruby-based command-line application that provides real-time monitoring of internet service providers (ISPs) and their data centers. This tool fetches data from the ArvanCloud API, allowing users to visualize the status of various ISPs and their data centers on their terminal.

## Features

- **Real-time Monitoring:** Get live updates on the status of ISPs and their data centers.
- **Color-Coded Visualization:** View ISPs and data centers in different colors for easy identification.
- **Time-Bar Display:** Track the time progress with a visual time bar.
- **Easy-to-Read Interface:** Simple and intuitive command-line interface for effortless monitoring.

## Prerequisites

Before you begin, ensure you have met the following requirements:

- Ruby installed on your system.
- `json`, `net/http`, and `io/console` Ruby gems installed.

## Installation

1. Clone the repository:

   ```shell
   git clone https://github.com/danielcoderx/arvanrdr.git
   ```

2. Navigate to the project directory:

   ```shell
   cd arvanrdr
   ```

3. Run the application:

   ```shell
   ruby main.rb
   ```

## Usage

- **ISP Data:** Ensure that the `arvan.json` file contains the necessary ISP information.
- **Run the Application:** Execute `main.rb` to start the monitoring dashboard.
- **View Monitoring Information:** The dashboard displays color-coded ISPs and their data centers, along with a time bar at the top.

## Configuration

In the `arvan.json` file, provide the following information for each ISP:

```json
[
  {
    "name": "ISP Name",
    "api": "ISP API Endpoint"
  },
  {
    "name": "Another ISP Name",
    "api": "Another ISP API Endpoint"
  }
]
```

## Contributing

1. Fork the project.
2. Create your feature branch: `git checkout -b feature/new-feature`
3. Commit your changes: `git commit -m 'Add some feature'`
4. Push to the branch: `git push origin feature/new-feature`
5. Submit a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**TODOs:**

- **Enhance Error Handling:** Implement more robust error handling mechanisms to gracefully handle various API response scenarios.
- **Dynamic Data Loading:** Add functionality to dynamically reload ISP data without restarting the application.
- **User Configuration:** Allow users to configure colors and other display preferences for a personalized experience.
- **Documentation:** Expand inline code comments for better readability and maintainability.
- **Unit Tests:** Develop unit tests to ensure the stability and reliability of the application.