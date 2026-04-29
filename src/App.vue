<template>
  <div ref="canvasContainer" class="canvas-container"></div>
</template>

<script setup>
import { onMounted, ref } from 'vue';
import * as THREE from 'three';
import * as CANNON from 'cannon-es';

const canvasContainer = ref(null);

onMounted(() => {
  // 1. إعداد عالم الفيزياء (Cannon.js)
  const world = new CANNON.World();
  // ضبط الجاذبية لتكون مضادة (دفع خفيف للأعلى)
  world.gravity.set(0, 0.5, 0); 

  // 2. إعداد مشهد الرسوميات (Three.js)
  const scene = new THREE.Scene();
  scene.background = new THREE.Color(0x050505);

  const camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
  camera.position.z = 5;

  const renderer = new THREE.WebGLRenderer({ antialias: true });
  renderer.setSize(window.innerWidth, window.innerHeight);
  canvasContainer.value.appendChild(renderer.domElement);

  // إضاءة
  const ambientLight = new THREE.AmbientLight(0xffffff, 0.5);
  scene.add(ambientLight);
  const pointLight = new THREE.PointLight(0x00ff88, 1);
  pointLight.position.set(5, 5, 5);
  scene.add(pointLight);

  // 3. إضافة كائنات (المصفوفة الرقمية)
  const spheres = [];
  const sphereCount = 20;

  for (let i = 0; i < sphereCount; i++) {
    // شكل الرسوميات
    const geometry = new THREE.SphereGeometry(0.2, 32, 32);
    const material = new THREE.MeshPhongMaterial({ color: 0x00ff88, wireframe: true });
    const mesh = new THREE.Mesh(geometry, material);
    scene.add(mesh);

    // جسم الفيزياء
    const body = new CANNON.Body({
      mass: 1,
      shape: new CANNON.Sphere(0.2),
      position: new CANNON.Vec3(
        (Math.random() - 0.5) * 4,
        (Math.random() - 0.5) * 4,
        (Math.random() - 0.5) * 4
      )
    });
    world.addBody(body);
    spheres.push({ mesh, body });
  }

  // 4. حلقة التحريك
  const animate = () => {
    requestAnimationFrame(animate);

    // تحديث الفيزياء
    world.fixedStep();

    // ربط الرسوميات بالفيزياء
    spheres.forEach(obj => {
      obj.mesh.position.copy(obj.body.position);
      obj.mesh.quaternion.copy(obj.body.quaternion);
      
      // إضافة قوة لإبقاء الكائنات داخل حدود معينة (سلوك سيادي ذاتي)
      if (obj.body.position.y > 5) obj.body.velocity.y -= 0.1;
      if (obj.body.position.y < -5) obj.body.velocity.y += 0.1;
    });

    renderer.render(scene, camera);
  };

  animate();

  window.addEventListener('resize', () => {
    camera.aspect = window.innerWidth / window.innerHeight;
    camera.updateProjectionMatrix();
    renderer.setSize(window.innerWidth, window.innerHeight);
  });
});
</script>

<style>
body { margin: 0; overflow: hidden; background: black; }
.canvas-container { width: 100vw; height: 100vh; }
</style>