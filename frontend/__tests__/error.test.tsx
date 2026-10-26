import { render, screen } from "@testing-library/react";
import Error from "../app/error";

describe("Error", () => {
    it("エラーの見出しを表示する", () => {
        render(<Error />);
        const heading = screen.getByRole("heading", {
            name: "存在しない見出し",
            level: 1,
        });
        expect(heading).toBeInTheDocument();
    });
});
