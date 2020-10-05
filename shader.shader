shader_type canvas_item;

uniform vec3 cam = vec3(0, 0, 0);
uniform vec3 light_pos = vec3(0, 0, 0);

uniform float time;

//const vec3 cam = vec3(0, 0, 0);
// const vec3 light_pos = vec3(0, 10, 10);

const float max_dist = 200.0;
const float min_dist = 0.001;
const float iterations = 200.0;

uniform float vis_range = 200.0;

uniform float angleY;
uniform float angleX;

float lerp(float start, float end, float t) {
	return start * (1.0 - t) + end * t;
}

float smin(float a, float b, float k) {
	float h = clamp(0.5 + 0.5 * (b - a) / k, 0.0, 1.0);
	return lerp(b, a, h) - k * h * (1.0 - h);
}


mat3 rotateX(float theta) {
    float c = cos(theta);
    float s = sin(theta);

    return mat3(
        vec3(1, 0, 0),
        vec3(0, c, -s),
        vec3(0, s, c)
    );
}

mat3 rotateY(float theta) {
    float c = cos(theta);
    float s = sin(theta);

    return mat3(
        vec3(c, 0, s),
        vec3(0, 1, 0),
        vec3(-s, 0, c)
    );
}

mat3 rotateZ(float theta) {
    float c = cos(theta);
    float s = sin(theta);

    return mat3(
        vec3(c, -s, 0),
        vec3(s, c, 0),
        vec3(0, 0, 1)
    );
}


float sphere(vec3 p, vec4 s) {
	return distance(p.xyz, s.xyz) - s.w;
}

float box(vec3 p, vec3 pb, vec3 b) {
	vec3 q = abs(p + pb) - b;
	return length(max(q, 0.0) + min(max(q.x, max(q.y,q.z)), 0.0));
}

float torus(vec3 p, vec3 tp, vec2 t) {
	p += tp;
	vec2 q = vec2(length(p.xz)-t.x,p.y);
	return length(q)-t.y;
}

float planeX(vec3 p, float h) {
	return p.x - h;
}

float planeY(vec3 p, float h) {
	return p.y - h;
}

float planeZ(vec3 p, float h) {
	return p.z - h;
}

float getDist(vec3 p) {
	float obj1 = planeY(p, -0.8);
	
	vec3 obj2_point = rotateY(time) * p;
	float obj2 = sphere(obj2_point, vec4(0, 0, 5, 2));
	
	return smin(obj1, obj2, 2);
}

vec3 getNorm(vec3 p) {
	float d = getDist(p);
	
	return normalize(vec3(d) - vec3(
		getDist(p - vec3(0.001, 0, 0)),
		getDist(p - vec3(0, 0.001, 0)),
		getDist(p - vec3(0, 0, 0.001))));
}

float get_light(vec3 p) {
	vec3 lp = light_pos;
	vec3 ld = normalize(light_pos - p);
	
	vec3 norm = getNorm(p);
	
	return dot(norm, ld) * 0.5 + 0.5;
}


float raymarch(vec3 ro, vec3 rd) {
	vec3 p = ro;
	
//	for (int i = 0; i < 2000; i++) {
//		float d = getDist(p);
//
//		if (d > max_dist) {
//			break;
//		}
//
//		if (d <= min_dist) {
//			return get_light(p) + float(20 - i) / 1000.0;
//		}
//
//		p += rd * d;
//	}
	
	while (distance(p, cam) < vis_range) {
		float d = getDist(p);
		
		if (d > max_dist) {
			break;
		}

		if (d <= min_dist) {
			return get_light(p);
		}

		p += rd * d;
	}
	
	return 0.0;
}

void fragment() {
	vec3 col = vec3(0);
	
	vec2 uv = vec2(0, 0);
	
	uv.x = FRAGCOORD.x / 1024.0 * 2.0 - 1.0;
	uv.x *= 1024.0 / 600.0;
	uv.y = FRAGCOORD.y / 600.0 * 2.0 - 1.0;
	
	vec3 rd = normalize(vec3(uv.x, uv.y, 1));
	
	rd = rotateX(-angleX) * rd;
	rd = rotateY(-angleY) * rd;
	
	col = vec3(raymarch(cam, rd));
	
	COLOR.rgb = col;
}