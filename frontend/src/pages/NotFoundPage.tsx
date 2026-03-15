import { Link } from "react-router-dom";

export default function NotFoundPage() {
  return (
    <div className="min-h-[60vh] flex flex-col items-center justify-center">
      <h1 className="text-6xl font-bold text-gray-300 mb-4">404</h1>
      <p className="text-gray-600 mb-6">Page not found</p>
      <Link to="/problems" className="text-blue-600 hover:underline">
        Go to Problems
      </Link>
    </div>
  );
}
