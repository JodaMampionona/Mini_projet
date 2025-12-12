CREATE TABLE "buses"(
    "id" BIGINT NOT NULL,
    "name" VARCHAR(255) NOT NULL
);
ALTER TABLE
    "buses" ADD PRIMARY KEY("id");
CREATE TABLE "bus_stops"(
    "id" BIGINT NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "lat" DOUBLE PRECISION NOT NULL,
    "lon" DOUBLE PRECISION NOT NULL
);
ALTER TABLE
    "bus_stops" ADD PRIMARY KEY("id");
CREATE TABLE "bus_stop_link"(
    "id" BIGINT NOT NULL,
    "bus_id" BIGINT NOT NULL,
    "stop_id" BIGINT NOT NULL,
    "rank" INTEGER NOT NULL
);
ALTER TABLE
    "bus_stop_link" ADD PRIMARY KEY("id");
ALTER TABLE
    "bus_stop_link" ADD CONSTRAINT "bus_stop_link_bus_id_foreign" FOREIGN KEY("bus_id") REFERENCES "buses"("id");
ALTER TABLE
    "bus_stop_link" ADD CONSTRAINT "bus_stop_link_stop_id_foreign" FOREIGN KEY("stop_id") REFERENCES "bus_stops"("id");