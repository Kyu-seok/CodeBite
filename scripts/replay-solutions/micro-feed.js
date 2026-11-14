class MicroFeed {
    constructor() {
        this.clock = 0;
        this.posts = new Map();
        this.following = new Map();
    }

    publishPost(userId, messageId) {
        if (!this.posts.has(userId)) this.posts.set(userId, []);
        this.posts.get(userId).push([this.clock++, messageId]);
    }

    latestFeed(userId) {
        const authors = new Set(this.following.get(userId) || []);
        authors.add(userId);
        const all = [];
        for (const author of authors) all.push(...(this.posts.get(author) || []));
        all.sort((a, b) => b[0] - a[0]);
        return all.slice(0, 10).map(post => post[1]);
    }

    subscribe(followerId, followeeId) {
        if (followerId === followeeId) return;
        if (!this.following.has(followerId)) this.following.set(followerId, new Set());
        this.following.get(followerId).add(followeeId);
    }

    unsubscribe(followerId, followeeId) {
        const set = this.following.get(followerId);
        if (set) set.delete(followeeId);
    }
}
