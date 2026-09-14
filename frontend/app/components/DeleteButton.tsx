"use client"

import { useRouter } from "next/navigation";

type Props = {
    id: number;
}

export default function DeleteButton({ id }: Props) {
    const router = useRouter();

    const handleDelete = async () => {
        const res = await fetch(`http://localhost:3001/tasks/${id}`, {
            method: "DELETE",
            credentials: "include",
        });

        if (res.ok) {
            router.refresh();
        }
    }

    return (
        <button onClick={handleDelete}>削除</button>
    );
}