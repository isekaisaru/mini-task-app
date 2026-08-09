export type Task = {
    id: number;
    user_id: number;
    title: string;
    duration_minutes: number;
    scheduled_on: string;
    completed: boolean;
    created_at: string;
    updated_at: string;
};