import type { Task } from "./types/task";

async function getTasks(): Promise<Task[]> {
  const res = await fetch("http://localhost:3001/tasks");

  return res.json();
}

export default async function Home() {
  const tasks = await getTasks();

  return (
    <main>
      <h1>ミニタスク一覧</h1>

      <ul>
        {tasks.map((task) => (
          <li key={task.id}>{task.title}</li>
        ))}
      </ul>
    </main>
  );
}