"use client"

import { useState } from "react"

export default function LoginPage() {
    const [email, setEmail] = useState("");
    const [password, setPassword] = useState("");
    const [loginStatus, setLoginStatus] = useState("");
    const [isLoggingIn, setIsLoggingIn] = useState(false);

    const handleSubmit = async (e: React.SubmitEvent<HTMLFormElement>) => {
        e.preventDefault();
        if (isLoggingIn) return;
        setIsLoggingIn(true);
        try {
            const res = await fetch("http://localhost:3001/sessions", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ email, password }),
                credentials: "include",
            });

            if (res.ok) {
                alert("ログインしました");
            } else {
                alert("ログインに失敗しました");
            }
        } catch {
            alert("ログイン中にエラーが発生しました");
        }
        finally {
            setIsLoggingIn(false);
        }
    };
    const handleCheckLogin = async () => {
        try {
            const res = await fetch("http://localhost:3001/me", {
                credentials: "include",
            });
            const data = await res.json();

            if (res.ok) {
                setLoginStatus(`ログインしています: ${data.email}`);
            } else {
                setLoginStatus(data.error);
            }
        } catch {
            setLoginStatus("ログイン状態を確認中にエラーが発生しました");
        }
    };

    return (
        <div>
            <h1>ログイン</h1>
            <form onSubmit={handleSubmit}>
                <label>
                    Email:
                    <input
                        type="email"
                        value={email}
                        onChange={(e) => setEmail(e.target.value)}
                    />
                </label>
                <br />
                <label>
                    Password:
                    <input
                        type="password"
                        value={password}
                        onChange={(e) => setPassword(e.target.value)}
                    />
                </label>
                <br />
                <button type="submit" disabled={isLoggingIn}>
                    {isLoggingIn ? "ログイン中..." : "ログイン"}
                </button>
            </form>
            <button type="button" onClick={handleCheckLogin}>
                ログイン状態を確認
            </button>
            <p>ログイン状態: {loginStatus}</p>
        </div>
    );
}