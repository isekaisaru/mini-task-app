import type { Task } from "./types/task";
import { headers } from "next/headers";
import TaskForm from "./components/TaskForm";
import DeleteButton from "./components/DeleteButton";
import UpdateButton from "./components/UpdateButton";

async function getTasks(): Promise<Task[]> {
  const requestsHeaders = await headers();
  const cookieHeader = requestsHeaders.get("Cookie");

  const res = await fetch("http://localhost:3001/tasks", {
    cache: "no-store",
    headers: cookieHeader
      ? {
        Cookie: cookieHeader,
      }
      : {},
  });

  if (!res.ok) {
    throw new Error("タスクを取得できませんでした");
  }

  return res.json();
}

export default async function Home() {
  const tasks = await getTasks();

  return (
    <main>
      <h1>ミニタスク一覧</h1>

      <ul>
        {tasks.length === 0 && <li>タスクはありません</li>}
        {tasks.map((task) => (
          <li key={task.id}>
            {task.title}
            <DeleteButton id={task.id} />
            <UpdateButton id={task.id} title={task.title} />
          </li>
        ))}
      </ul>

      <h2>タスクの追加</h2>
      <TaskForm />
    </main>
  );
}
