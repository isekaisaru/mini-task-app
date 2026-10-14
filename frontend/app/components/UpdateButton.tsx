"use client"

import { useRouter } from "next/navigation";
import { useState } from "react";

type Props = {
    id: number;
    title: string;
}

export default function UpdateButton({ id, title }: Props) {
    const router = useRouter();
    const [editedTitle, setEditedTitle] = useState(title);
    const apiUrl = process.env.NEXT_PUBLIC_API_URL ?? "http://localhost:3001";

    const handleUpdate = async () => {
        const res = await fetch(`${apiUrl}/tasks/${id}`, {
            method: "PATCH",
            credentials: "include",
            headers: {
                "Content-Type": "application/json",
            },
            body: JSON.stringify({
                task: {
                    title: editedTitle
                }
            }),
        });

        if (res.ok) {
            router.refresh();
        }
    }
    return (
        <div>
            <input
                value={editedTitle}
                onChange={(e) => setEditedTitle(e.target.value)}
            />
            <button onClick={handleUpdate}>更新</button>
        </div>
    )
}