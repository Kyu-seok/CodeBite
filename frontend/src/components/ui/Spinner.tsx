export default function Spinner() {
  return (
    <div className="flex justify-center items-center p-8">
      <div className="h-8 w-8 border-4 border-muted-foreground/30 border-t-accent-500 rounded-full animate-spin" />
    </div>
  );
}
