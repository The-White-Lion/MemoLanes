use std::{fs::File, io::Write};

use criterion::{criterion_group, criterion_main, Criterion};

use memolanes_core::{
    import_data, journey_bitmap::JourneyBitmap, merged_journey_builder, renderer::*,
};

fn map_renderer(c: &mut Criterion) {
    let mut group = c.benchmark_group("map_renderer");
    group.sample_size(10);
    group.bench_function("nelson_to_wharariki_beach", |b| {
        let raw_data = import_data::load_gpx("./tests/data/nelson_to_wharariki_beach.gpx").unwrap();

        let (mut left, mut right, mut top, mut bottom): (f64, f64, f64, f64) =
            (180., -180., -90., 90.);
        raw_data.iter().for_each(|x| {
            x.iter().for_each(|raw_data| {
                left = left.min(raw_data.longitude);
                right = right.max(raw_data.longitude);
                top = top.max(raw_data.latitude);
                bottom = bottom.min(raw_data.latitude);
            })
        });

        let journey_vector = import_data::journey_vector_from_raw_data(raw_data, false).unwrap();
        let mut journey_bitmap = JourneyBitmap::new();
        merged_journey_builder::add_journey_vector_to_journey_bitmap(
            &mut journey_bitmap,
            &journey_vector,
        );

        let mut map_renderer = MapRenderer::new(journey_bitmap);
        let zoom = 11;

        let render_result = map_renderer.maybe_render_map_overlay(zoom, left, top, right, bottom);
        let mut f = File::create("./benches/for_inspection/nelson_to_wharariki_beach.png").unwrap();
        f.write_all(&render_result.unwrap().data).unwrap();
        drop(f);

        b.iter(|| {
            std::hint::black_box({
                map_renderer.reset();
                let render_result =
                    map_renderer.maybe_render_map_overlay(zoom, left, top, right, bottom);
                render_result.unwrap();
            });
        });
    });
    group.finish();
}

criterion_group!(benches, map_renderer,);
criterion_main!(benches);
