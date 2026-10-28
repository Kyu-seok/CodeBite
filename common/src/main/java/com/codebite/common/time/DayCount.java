package com.codebite.common.time;

import java.time.LocalDate;

/** How many of something happened on one calendar day. */
public record DayCount(LocalDate day, long count) {
}
