import confetti from "canvas-confetti";

export function fireConfetti() {
  // One short burst from a centered low origin — feels like the page itself is celebrating.
  confetti({
    particleCount: 140,
    spread: 75,
    startVelocity: 45,
    origin: { x: 0.5, y: 0.65 },
    ticks: 200,
    scalar: 1.0,
  });
  // Side-flanking pops for a richer effect without overwhelming.
  setTimeout(() => {
    confetti({
      particleCount: 60,
      spread: 60,
      angle: 60,
      origin: { x: 0.1, y: 0.8 },
    });
    confetti({
      particleCount: 60,
      spread: 60,
      angle: 120,
      origin: { x: 0.9, y: 0.8 },
    });
  }, 150);
}
