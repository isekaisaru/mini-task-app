'use client'
import { useState } from "react";


export default function TaskForm() {
    const [title, setTitle] = useState('');
    const [durationMinutes, setDurationMinutes] = useState("15");
    const [scheduledOn, setScheduledOn] = useState('');



    return (
        <form onSubmit={(e) => { e.preventDefault(); }} >
            <label htmlFor="title">タイトル</label>
            <input id="title" name="title" type="text" value={title} onChange={(e) => setTitle(e.target.value)} />
            <label htmlFor="duration_minutes">実行時間</label>
            <input id="duration_minutes" name="duration_minutes" type="number" value={durationMinutes} onChange={(e) => setDurationMinutes(e.target.value)} />
            <label htmlFor="scheduled_on">実行日</label>
            <input id="scheduled_on" name="scheduled_on" type="date" value={scheduledOn} onChange={(e) => setScheduledOn(e.target.value)} />
            <button type="submit">タスクを作成</button>
        </form>
    );
}