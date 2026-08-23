'use client'
import { useState } from "react";
import { useRouter } from "next/navigation";

export default function TaskForm() {
    const [title, setTitle] = useState('');
    const [durationMinutes, setDurationMinutes] = useState("15");
    const [scheduledOn, setScheduledOn] = useState('');
    const [message, setMessage] = useState('');
    const [isSubmitting, setIsSubmitting] = useState(false);
    const router = useRouter();

    const handleSubmit = async (e: React.SubmitEvent<HTMLFormElement>) => {
        e.preventDefault();
        if (isSubmitting) return;
        setIsSubmitting(true);
        const task = {
            title,
            duration_minutes: Number(durationMinutes),
            scheduled_on: scheduledOn,
            user_id: 1,
        };
        try {

            const res = await fetch('http://localhost:3001/tasks', {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                },
                body: JSON.stringify({ task }),
            });
            if (res.ok) {
                setTitle('');
                setDurationMinutes("15");
                setScheduledOn('');
                setMessage('タスクが作成されました');
                router.refresh();
            } else {
                const data = await res.json();
                setMessage(data.errors[0] || 'タスクの作成に失敗しました');
            }
        } catch {
            setMessage("タスクの作成に失敗しました");
        } finally {
            setIsSubmitting(false);

        }
    };



    return (
        <form onSubmit={handleSubmit} >
            <label htmlFor="title">タイトル</label>
            <input id="title" name="title" type="text" value={title} onChange={(e) => setTitle(e.target.value)} />
            <label htmlFor="duration_minutes">実行時間</label>
            <input id="duration_minutes" name="duration_minutes" type="number" value={durationMinutes} onChange={(e) => setDurationMinutes(e.target.value)} />
            <label htmlFor="scheduled_on">実行日</label>
            <input id="scheduled_on" name="scheduled_on" type="date" value={scheduledOn} onChange={(e) => setScheduledOn(e.target.value)} />
            <button type="submit" disabled={isSubmitting}>
                {isSubmitting ? 'タスクを作成中...' : 'タスクを作成'}</button>
            {message && <p>{message}</p>}
        </form>
    );
}