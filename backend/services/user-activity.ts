import { Collection, ObjectId } from "mongo";
import { logger } from "./logger.ts";
import { database } from "./database.ts";
import {
  ActivityCategory,
  ActivityType,
  UserActivityDocument,
  UserActivityFilters,
} from "../interfaces/user-activity.ts";

export class UserActivityService {
  private getUserActivitiesCollection():
    | Collection<UserActivityDocument>
    | null {
    return database.getUserActivitiesCollection();
  }

  /**
   * Create a new user activity record
   */
  public async createActivity(
    data: Omit<UserActivityDocument, "_id" | "createdAt" | "updatedAt">,
  ): Promise<string | null> {
    const collection = this.getUserActivitiesCollection();
    if (!collection) {
      logger.warn("User activities collection is null, skipping activity creation");
      return null;
    }

    try {
      const now = new Date();
      const activity: UserActivityDocument = {
        ...data,
        timestamp: data.timestamp || now,
        createdAt: now,
        updatedAt: now,
      };

      const result = await collection.insertOne(activity);
      logger.info(`User activity created: ${data.activityType} by ${data.username || data.userId}`);
      return result.toString();
    } catch (error) {
      const errorMsg = error instanceof Error ? error.message : String(error);
      logger.error(`Failed to create user activity: ${errorMsg}`, error);
      return null;
    }
  }

  /**
   * Get user activity by ID
   */
  public async getActivityById(id: string): Promise<UserActivityDocument | null> {
    const collection = this.getUserActivitiesCollection();
    if (!collection) return null;

    try {
      const activity = await collection.findOne({ _id: new ObjectId(id) });
      return activity || null;
    } catch (error) {
      logger.error("Failed to get activity by ID", error);
      return null;
    }
  }

  /**
   * Get all activities with pagination
   */
  public async getAllActivities(
    limit = 100,
    skip = 0,
  ): Promise<UserActivityDocument[]> {
    const collection = this.getUserActivitiesCollection();
    if (!collection) return [];

    try {
      const activities = await collection
        .find({})
        .sort({ timestamp: -1 })
        .limit(limit)
        .skip(skip)
        .toArray();
      return activities;
    } catch (error) {
      logger.error("Failed to get all activities", error);
      return [];
    }
  }

  /**
   * Get activities by user ID
   */
  public async getActivitiesByUserId(
    userId: string,
    limit = 100,
    skip = 0,
  ): Promise<UserActivityDocument[]> {
    const collection = this.getUserActivitiesCollection();
    if (!collection) return [];

    try {
      const activities = await collection
        .find({ userId })
        .sort({ timestamp: -1 })
        .limit(limit)
        .skip(skip)
        .toArray();
      return activities;
    } catch (error) {
      logger.error("Failed to get activities by user ID", error);
      return [];
    }
  }

  /**
   * Get activities by username
   */
  public async getActivitiesByUsername(
    username: string,
    limit = 100,
    skip = 0,
  ): Promise<UserActivityDocument[]> {
    const collection = this.getUserActivitiesCollection();
    if (!collection) return [];

    try {
      const activities = await collection
        .find({ username })
        .sort({ timestamp: -1 })
        .limit(limit)
        .skip(skip)
        .toArray();
      return activities;
    } catch (error) {
      logger.error("Failed to get activities by username", error);
      return [];
    }
  }

  /**
   * Get activities by type
   */
  public async getActivitiesByType(
    activityType: ActivityType | string,
    limit = 100,
    skip = 0,
  ): Promise<UserActivityDocument[]> {
    const collection = this.getUserActivitiesCollection();
    if (!collection) return [];

    try {
      const activities = await collection
        .find({ activityType })
        .sort({ timestamp: -1 })
        .limit(limit)
        .skip(skip)
        .toArray();
      return activities;
    } catch (error) {
      logger.error("Failed to get activities by type", error);
      return [];
    }
  }

  /**
   * Get activities by category
   */
  public async getActivitiesByCategory(
    activityCategory: ActivityCategory | string,
    limit = 100,
    skip = 0,
  ): Promise<UserActivityDocument[]> {
    const collection = this.getUserActivitiesCollection();
    if (!collection) return [];

    try {
      const activities = await collection
        .find({ activityCategory })
        .sort({ timestamp: -1 })
        .limit(limit)
        .skip(skip)
        .toArray();
      return activities;
    } catch (error) {
      logger.error("Failed to get activities by category", error);
      return [];
    }
  }

  /**
   * Search activities with filters
   */
  public async searchActivities(
    filters: UserActivityFilters,
    limit = 100,
    skip = 0,
  ): Promise<UserActivityDocument[]> {
    const collection = this.getUserActivitiesCollection();
    if (!collection) return [];

    try {
      const query: any = {};

      if (filters.userId) query.userId = filters.userId;
      if (filters.username) query.username = { $regex: filters.username, $options: "i" };
      if (filters.activityType) query.activityType = filters.activityType;
      if (filters.activityCategory) query.activityCategory = filters.activityCategory;
      if (filters.ipAddress) query.ipAddress = filters.ipAddress;
      if (filters.targetId) query.targetId = filters.targetId;
      if (filters.targetType) query.targetType = filters.targetType;

      // Date range filter
      if (filters.startDate || filters.endDate) {
        query.timestamp = {};
        if (filters.startDate) query.timestamp.$gte = filters.startDate;
        if (filters.endDate) query.timestamp.$lte = filters.endDate;
      }

      const activities = await collection
        .find(query)
        .sort({ timestamp: -1 })
        .limit(limit)
        .skip(skip)
        .toArray();

      return activities;
    } catch (error) {
      logger.error("Failed to search activities", error);
      return [];
    }
  }

  /**
   * Count total activities
   */
  public async countActivities(filters?: UserActivityFilters): Promise<number> {
    const collection = this.getUserActivitiesCollection();
    if (!collection) return 0;

    try {
      if (!filters) {
        return await collection.countDocuments({});
      }

      const query: any = {};
      if (filters.userId) query.userId = filters.userId;
      if (filters.username) query.username = { $regex: filters.username, $options: "i" };
      if (filters.activityType) query.activityType = filters.activityType;
      if (filters.activityCategory) query.activityCategory = filters.activityCategory;
      if (filters.ipAddress) query.ipAddress = filters.ipAddress;
      if (filters.targetId) query.targetId = filters.targetId;
      if (filters.targetType) query.targetType = filters.targetType;

      if (filters.startDate || filters.endDate) {
        query.timestamp = {};
        if (filters.startDate) query.timestamp.$gte = filters.startDate;
        if (filters.endDate) query.timestamp.$lte = filters.endDate;
      }

      return await collection.countDocuments(query);
    } catch (error) {
      logger.error("Failed to count activities", error);
      return 0;
    }
  }

  /**
   * Delete activity by ID
   */
  public async deleteActivity(id: string): Promise<boolean> {
    const collection = this.getUserActivitiesCollection();
    if (!collection) return false;

    try {
      const result = await collection.deleteOne({ _id: new ObjectId(id) });
      logger.info(`Activity ${id} deleted successfully`);
      return result > 0;
    } catch (error) {
      logger.error("Failed to delete activity", error);
      return false;
    }
  }

  /**
   * Delete activities by user ID
   */
  public async deleteActivitiesByUserId(userId: string): Promise<number> {
    const collection = this.getUserActivitiesCollection();
    if (!collection) return 0;

    try {
      const result = await collection.deleteMany({ userId });
      logger.info(`Deleted ${result} activities for user ${userId}`);
      return result;
    } catch (error) {
      logger.error("Failed to delete activities by user ID", error);
      return 0;
    }
  }

  /**
   * Delete old activities (older than specified days)
   */
  public async deleteOldActivities(daysOld: number): Promise<number> {
    const collection = this.getUserActivitiesCollection();
    if (!collection) return 0;

    try {
      const cutoffDate = new Date();
      cutoffDate.setDate(cutoffDate.getDate() - daysOld);

      const result = await collection.deleteMany({
        timestamp: { $lt: cutoffDate },
      });

      logger.info(`Deleted ${result} activities older than ${daysOld} days`);
      return result;
    } catch (error) {
      logger.error("Failed to delete old activities", error);
      return 0;
    }
  }

  /**
   * Get activity statistics
   */
  public async getActivityStats(userId?: string): Promise<{
    totalActivities: number;
    byType: Record<string, number>;
    byCategory: Record<string, number>;
    recentActivities: number;
  }> {
    const collection = this.getUserActivitiesCollection();
    if (!collection) {
      return {
        totalActivities: 0,
        byType: {},
        byCategory: {},
        recentActivities: 0,
      };
    }

    try {
      const matchStage = userId ? { userId } : {};

      // Get total count
      const totalActivities = await collection.countDocuments(matchStage);

      // Get count by type
      const byTypeResult = await collection.aggregate([
        { $match: matchStage },
        { $group: { _id: "$activityType", count: { $sum: 1 } } },
      ]).toArray();

      const byType: Record<string, number> = {};
      byTypeResult.forEach((item: any) => {
        byType[item._id] = item.count;
      });

      // Get count by category
      const byCategoryResult = await collection.aggregate([
        { $match: matchStage },
        { $group: { _id: "$activityCategory", count: { $sum: 1 } } },
      ]).toArray();

      const byCategory: Record<string, number> = {};
      byCategoryResult.forEach((item: any) => {
        byCategory[item._id] = item.count;
      });

      // Get recent activities (last 24 hours)
      const oneDayAgo = new Date();
      oneDayAgo.setDate(oneDayAgo.getDate() - 1);

      const recentActivities = await collection.countDocuments({
        ...matchStage,
        timestamp: { $gte: oneDayAgo },
      });

      return {
        totalActivities,
        byType,
        byCategory,
        recentActivities,
      };
    } catch (error) {
      logger.error("Failed to get activity stats", error);
      return {
        totalActivities: 0,
        byType: {},
        byCategory: {},
        recentActivities: 0,
      };
    }
  }

  /**
   * Helper method to track login activity
   */
  public async trackLogin(
    userId: string,
    username: string,
    email: string,
    ipAddress?: string,
    userAgent?: string,
    success = true,
  ): Promise<string | null> {
    return await this.createActivity({
      userId,
      username,
      email,
      activityType: success ? ActivityType.LOGIN : ActivityType.LOGIN_FAILED,
      activityCategory: ActivityCategory.AUTHENTICATION,
      action: success ? "User logged in" : "Login attempt failed",
      ipAddress,
      userAgent,
      timestamp: new Date(),
    });
  }

  /**
   * Helper method to track logout activity
   */
  public async trackLogout(
    userId: string,
    username: string,
    email: string,
    ipAddress?: string,
    userAgent?: string,
  ): Promise<string | null> {
    return await this.createActivity({
      userId,
      username,
      email,
      activityType: ActivityType.LOGOUT,
      activityCategory: ActivityCategory.AUTHENTICATION,
      action: "User logged out",
      ipAddress,
      userAgent,
      timestamp: new Date(),
    });
  }
}

// Export singleton instance
export const userActivityService = new UserActivityService();
