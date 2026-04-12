const path = require('node:path');

const PREFS_PATH = path.join(process.env.HOME, 'Library/Application Support/Vivaldi/Default/Preferences');
const CONFIG_PATH = path.join(__dirname, 'preferences.json');

module.exports = {
    PREFS_PATH,
    CONFIG_PATH
};
