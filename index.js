const Agenda = require("agenda");

// MongoDB connection string
const mongoConnectionString = "mongodb://127.0.0.1/agenda";

// Initialize Agenda with the database connection
const agenda = new Agenda({ db: { address: mongoConnectionString } });

// Define a job that will log a message
agenda.define("daily status check", async (job) => {
  const currentTime = new Date();
  const formattedTime = currentTime.toLocaleString("en-IN", {
    timeZone: "Asia/Kolkata",
  });

  console.log("Everything is working fine!");
  console.log("Current time:", formattedTime);
});

(async function () {
  try {
    // Start the agenda instance
    await agenda.start();

    // To run the job every 1 minute for a daily status check
    // await agenda.every("1 minute", "daily status check", {
    //   timezone: "Asia/Kolkata",
    // });

    // To run the job every 5 seconds for a daily status check
    // await agenda.every("5 seconds", "daily status check", {
    //   timezone: "Asia/Kolkata",
    // });

    // To run the job every 1 hour for a daily status check
    // await agenda.every("1 hour", "daily status check", {
    //   timezone: "Asia/Kolkata",
    // });

    // To run the job every day at 4:45 PM IST for a daily status check
    // await agenda.every("45 minutes past 4 PM", "daily status check", {
    //   timezone: "Asia/Kolkata",
    // });

    // await agenda.every("14 17 * * *", "daily status check", {
    //   timezone: "Asia/Kolkata",
    // });

    // await agenda.every("20 17 * * *", "daily status check", null, {
    //   timezone: "Asia/Kolkata",
    // });
    await agenda.every("5 minute", "daily status check", null, {
      timezone: "Asia/Kolkata",
    });

    console.log("Job scheduled to run every day at 11:40 AM IST.");
  } catch (err) {
    console.error("Error starting agenda:", err);
  }
})();

// Graceful shutdown handling
process.on("SIGTERM", gracefulShutdown);
process.on("SIGINT", gracefulShutdown);

async function gracefulShutdown() {
  await agenda.stop();
  process.exit(0);
}
