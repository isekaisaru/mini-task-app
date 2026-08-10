import type { Task } from "./types/task";

async function getTasks(): Promise<Task[]> {
  const res = await fetch("http://localhost:3001/tasks");

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
          <li key={task.id}>{task.title}</li>
        ))}
      </ul>
    </main>
  );
}