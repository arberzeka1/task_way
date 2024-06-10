/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const functions = require("firebase-functions");
const admin = require("firebase-admin");
const Status = {
  TODO: "Todo",
  IN_PROGRESS: "InProgress",
  DONE: "Done",
};

const TaskType = {
  Task: "Task",
  Story: "Story",
  Bug: "Bug",
};

admin.initializeApp();

exports.getHistoryData = functions.https.onCall(async (data, context) => {
  try {
    const querySnapshot = await admin
        .firestore()
        .collection("tasks")
        .orderBy("timestamp", "desc")
        .get();

    const historiesList = [];
    querySnapshot.forEach((document) => {
      const {
        taskId,
        title,
        description,
        status,
        timeSpent,
        taskType,
        completionDate,
        comments,
      } = document.data();
      const formattedCompletionDate = completionDate || null;
      historiesList.push({
        taskId,
        title,
        description,
        status,
        taskType,
        timeSpent,
        completionDate: formattedCompletionDate,
        comments,
      });
    });
    console.log("Histories List:", historiesList);
    return historiesList;
  } catch (error) {
    console.error(error);
    throw new functions.https.HttpsError("internal", "Error getting data");
  }
});

/**
 * Add created task.
 * @param {taskId} taskId.
 * @param {title} title.
 * @param {description} description.
 * @param {status} status .
 * @param {taskType} taskType .
 */
exports.saveToFirestore = functions.https.onCall(async (data, context) => {
  const {
    taskId,
    title,
    description,
    status,
    comments,
    timeSpent,
    completionDate,
    taskType,
  } = data;

  if (!Object.values(Status).includes(status)) {
    throw new functions.https.HttpsError("invalid-argument", "Invalid status");
  }
  if (!Object.values(TaskType).includes(taskType)) {
    throw new functions.https.HttpsError(
        "invalid-argument",
        "Invalid taskType",
    );
  }
  if (comments && !Array.isArray(comments)) {
    throw new functions.https.HttpsError(
        "invalid-argument",
        "Comments must be an array",
    );
  }

  const firestore = admin.firestore();

  try {
    await firestore.collection("tasks").add({
      taskId,
      title,
      description,
      status,
      taskType,
      comments: comments || [],
      timeSpent: timeSpent !== undefined ? timeSpent : null,
      completionDate: completionDate !== undefined ? completionDate : null,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
    });
    return {success: true};
  } catch (error) {
    console.log("Error $error");
    throw new functions.https.HttpsError("unknown", error.message, error);
  }
});

exports.deleteTask = functions.https.onCall(async (data, context) => {
  const {taskId} = data;

  if (!taskId) {
    throw new functions.https.HttpsError(
        "invalid-argument",
        "Task ID is required",
    );
  }

  const firestore = admin.firestore();

  try {
    const tasksCollection = firestore.collection("tasks");
    const taskSnapshot = await tasksCollection
        .where("taskId", "==", taskId)
        .get();

    if (taskSnapshot.empty) {
      throw new functions.https.HttpsError("not-found", "Task not found");
    }

    const batch = firestore.batch();
    taskSnapshot.forEach((doc) => {
      batch.delete(doc.ref);
    });

    await batch.commit();
    return {success: true};
  } catch (error) {
    console.log("Error", error);
    throw new functions.https.HttpsError("unknown", error.message, error);
  }
});

exports.deleteComment = functions.https.onCall(async (data, context) => {
  const {taskId, commentId} = data;

  if (!taskId || !commentId) {
    throw new functions.https.HttpsError(
        "invalid-argument",
        "Task ID and Comment ID are required",
    );
  }

  const firestore = admin.firestore();

  try {
    const tasksCollection = firestore.collection("tasks");
    const taskSnapshot = await tasksCollection
        .where("taskId", "==", taskId)
        .get();

    if (taskSnapshot.empty) {
      throw new functions.https.HttpsError("not-found", "Task not found");
    }

    const batch = firestore.batch();
    taskSnapshot.forEach((doc) => {
      const taskData = doc.data();
      const comments = taskData.comments || [];
      const updatedComments = comments.filter(
          (comment) => comment.commentId !== commentId,
      );

      batch.update(doc.ref, {comments: updatedComments});
    });

    await batch.commit();
    return {success: true};
  } catch (error) {
    console.log("Error", error);
    throw new functions.https.HttpsError("unknown", error.message, error);
  }
});

exports.updateTask = functions.https.onCall(async (data, context) => {
  const {
    taskId,
    title,
    description,
    status,
    comments,
    timeSpent,
    taskType,
    completionDate,
  } = data;

  if (!taskId) {
    throw new functions.https.HttpsError(
        "invalid-argument",
        "Task ID is required",
    );
  }

  if (status && !Object.values(Status).includes(status)) {
    throw new functions.https.HttpsError("invalid-argument", "Invalid status");
  }

  if (taskType && !Object.values(TaskType).includes(taskType)) {
    throw new functions.https.HttpsError(
        "invalid-argument",
        "Invalid taskType",
    );
  }

  const firestore = admin.firestore();

  try {
    const tasksCollection = firestore.collection("tasks");
    const taskSnapshot = await tasksCollection
        .where("taskId", "==", taskId)
        .get();

    if (taskSnapshot.empty) {
      throw new functions.https.HttpsError("not-found", "Task not found");
    }

    const batch = firestore.batch();
    taskSnapshot.forEach((doc) => {
      const updates = {};
      if (title !== undefined) updates.title = title;
      if (description !== undefined) updates.description = description;
      if (status !== undefined) updates.status = status;
      if (taskType !== undefined) updates.taskType = taskType;
      if (comments !== undefined) updates.comments = comments;
      if (timeSpent !== undefined) updates.timeSpent = timeSpent;
      if (completionDate !== undefined) updates.completionDate = completionDate;

      batch.update(doc.ref, updates);
    });

    await batch.commit();
    return {success: true};
  } catch (error) {
    console.log("Error", error);
    throw new functions.https.HttpsError("unknown", error.message, error);
  }
});
