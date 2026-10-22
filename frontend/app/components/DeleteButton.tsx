"use client"

import { useRouter } from "next/navigation";

type Props = {
    id: number;
}

export default function DeleteButton({ id }: Props) {
    const router = useRouter();
    const apiUrl = process.env.NEXT_PUBLIC_API_URL ?? "http://localhost:3001";

    const handleDelete = async () => {
        const res = await fetch(`${apiUrl}/tasks/${id}`, {
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