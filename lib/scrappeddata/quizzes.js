const admin = require('firebase-admin');
const fs = require('fs-extra');
const yaml = require('yamljs');

admin.initializeApp({
    credential: admin.credential.cert(require('./credentials.json')),
});
const db = admin.firestore();

const quizzes = [
    'adjective-easy1', 'adjective-easy2', 'adjective-easy3', 'adjective-easy4', 'adjective-easy5',
    'adjective-medium1', 'adjective-medium2', 'adjective-medium3', 'adjective-medium4', 'adjective-medium5',
    'adjective-hard1', 'adjective-hard2', 'adjective-hard3', 'adjective-hard4', 'adjective-hard5',

    'verb-easy1', 'verb-easy2', 'verb-easy3', 'verb-easy4', 'verb-easy5',
    'verb-medium1', 'verb-medium2', 'verb-medium3', 'verb-medium4', 'verb-medium5',
    'verb-hard1', 'verb-hard2', 'verb-hard3', 'verb-hard4', 'verb-hard5',

    'noun-easy1', 'noun-easy2', 'noun-easy3', 'noun-easy4', 'noun-easy5',
    'noun-medium1', 'noun-medium2', 'noun-medium3', 'noun-medium4', 'noun-medium5',
    'noun-hard1', 'noun-hard2', 'noun-hard3', 'noun-hard4', 'noun-hard5'
];

const update = async (quizId) => {
    try {
        // Read the YAML file content
        let yamlContent = fs.readFileSync(`quizzes/${quizId}.yaml`, 'utf8');

        // Clean up any problematic quotes (triple quotes or unescaped quotes)
        yamlContent = yamlContent.replace(/'''/g, "'"); // Fix triple single quotes
        yamlContent = yamlContent.replace(/"""/g, '"'); // Fix triple double quotes
        yamlContent = yamlContent.replace(/''/g, '"'); // Handle any other double single quotes cases

        // Parse the cleaned YAML content
        const json = yaml.parse(yamlContent);
        console.log(`Updating quiz: ${quizId}`);

        // Reference to Firestore document
        const ref = db.collection('quizzes').doc(quizId);
        await ref.set(json, { merge: true });

        console.log(`Updated quiz: ${quizId}`);
    } catch (error) {
        console.error(`Failed to update quiz ${quizId}:`, error);
    }
};

// Using Promise.all() to update all quizzes in parallel
const updateAllQuizzes = async () => {
    try {
        const promises = quizzes.map(quizId => update(quizId));
        await Promise.all(promises); // Wait for all updates to complete
        console.log('All quizzes updated');
    } catch (error) {
        console.error('Error updating quizzes:', error);
    }
};

updateAllQuizzes();
